SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: timescaledb; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS timescaledb WITH SCHEMA public;


--
-- Name: EXTENSION timescaledb; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION timescaledb IS 'Enables scalable inserts and complex queries for time-series data';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: blueprint_activity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.blueprint_activity AS ENUM (
    'copying',
    'invention',
    'manufacturing',
    'reaction',
    'research_material',
    'research_time'
);


--
-- Name: celestial_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.celestial_type AS ENUM (
    'asteroid_belt',
    'moon',
    'planet',
    'secondary_sun',
    'star'
);


--
-- Name: esi_grant_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.esi_grant_status AS ENUM (
    'requested',
    'approved',
    'rejected',
    'revoked'
);


--
-- Name: esi_token_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.esi_token_status AS ENUM (
    'requested',
    'approved',
    'rejected',
    'authorized',
    'revoked',
    'expired'
);


--
-- Name: market_order_range; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.market_order_range AS ENUM (
    'station',
    'region',
    'solarsystem',
    '1',
    '2',
    '3',
    '4',
    '5',
    '10',
    '20',
    '30',
    '40'
);


--
-- Name: market_order_snapshot_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.market_order_snapshot_status AS ENUM (
    'pending',
    'fetching',
    'fetched',
    'failed',
    'skipped'
);


--
-- Name: market_order_source_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.market_order_source_status AS ENUM (
    'pending',
    'fetching',
    'fetched',
    'fetching_failed',
    'disabled'
);


--
-- Name: market_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.market_status AS ENUM (
    'draft',
    'pending',
    'aggregating',
    'aggregated',
    'aggregating_failed',
    'disabled'
);


--
-- Name: static_data_version_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.static_data_version_status AS ENUM (
    'pending',
    'downloading',
    'downloaded',
    'downloading_failed',
    'importing',
    'imported',
    'importing_failed'
);


--
-- Name: universe; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.universe AS ENUM (
    'abyssal',
    'eve',
    'void',
    'wormhole'
);


--
-- Name: logidze_capture_exception(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_capture_exception(error_data jsonb) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
  -- version: 1
BEGIN
  -- Feel free to change this function to change Logidze behavior on exception.
  --
  -- Return `false` to raise exception or `true` to commit record changes.
  --
  -- `error_data` contains:
  --   - returned_sqlstate
  --   - message_text
  --   - pg_exception_detail
  --   - pg_exception_hint
  --   - pg_exception_context
  --   - schema_name
  --   - table_name
  -- Learn more about available keys:
  -- https://www.postgresql.org/docs/9.6/plpgsql-control-structures.html#PLPGSQL-EXCEPTION-DIAGNOSTICS-VALUES
  --

  return false;
END;
$$;


--
-- Name: logidze_compact_history(jsonb, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_compact_history(log_data jsonb, cutoff integer DEFAULT 1) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  -- version: 1
  DECLARE
    merged jsonb;
  BEGIN
    LOOP
      merged := jsonb_build_object(
        'ts',
        log_data#>'{h,1,ts}',
        'v',
        log_data#>'{h,1,v}',
        'c',
        (log_data#>'{h,0,c}') || (log_data#>'{h,1,c}')
      );

      IF (log_data#>'{h,1}' ? 'm') THEN
        merged := jsonb_set(merged, ARRAY['m'], log_data#>'{h,1,m}');
      END IF;

      log_data := jsonb_set(
        log_data,
        '{h}',
        jsonb_set(
          log_data->'h',
          '{1}',
          merged
        ) - 0
      );

      cutoff := cutoff - 1;

      EXIT WHEN cutoff <= 0;
    END LOOP;

    return log_data;
  END;
$$;


--
-- Name: logidze_filter_keys(jsonb, text[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_filter_keys(obj jsonb, keys text[], include_columns boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  -- version: 1
  DECLARE
    res jsonb;
    key text;
  BEGIN
    res := '{}';

    IF include_columns THEN
      FOREACH key IN ARRAY keys
      LOOP
        IF obj ? key THEN
          res = jsonb_insert(res, ARRAY[key], obj->key);
        END IF;
      END LOOP;
    ELSE
      res = obj;
      FOREACH key IN ARRAY keys
      LOOP
        res = res - key;
      END LOOP;
    END IF;

    RETURN res;
  END;
$$;


--
-- Name: logidze_logger(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_logger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  -- version: 2
  DECLARE
    changes jsonb;
    version jsonb;
    snapshot jsonb;
    new_v integer;
    size integer;
    history_limit integer;
    debounce_time integer;
    current_version integer;
    k text;
    iterator integer;
    item record;
    columns text[];
    include_columns boolean;
    ts timestamp with time zone;
    ts_column text;
    err_sqlstate text;
    err_message text;
    err_detail text;
    err_hint text;
    err_context text;
    err_table_name text;
    err_schema_name text;
    err_jsonb jsonb;
    err_captured boolean;
  BEGIN
    ts_column := NULLIF(TG_ARGV[1], 'null');
    columns := NULLIF(TG_ARGV[2], 'null');
    include_columns := NULLIF(TG_ARGV[3], 'null');

    IF TG_OP = 'INSERT' THEN
      IF columns IS NOT NULL THEN
        snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns, include_columns);
      ELSE
        snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column);
      END IF;

      IF snapshot#>>'{h, -1, c}' != '{}' THEN
        NEW.log_data := snapshot;
      END IF;

    ELSIF TG_OP = 'UPDATE' THEN

      IF OLD.log_data is NULL OR OLD.log_data = '{}'::jsonb THEN
        IF columns IS NOT NULL THEN
          snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns, include_columns);
        ELSE
          snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column);
        END IF;

        IF snapshot#>>'{h, -1, c}' != '{}' THEN
          NEW.log_data := snapshot;
        END IF;
        RETURN NEW;
      END IF;

      history_limit := NULLIF(TG_ARGV[0], 'null');
      debounce_time := NULLIF(TG_ARGV[4], 'null');

      current_version := (NEW.log_data->>'v')::int;

      IF ts_column IS NULL THEN
        ts := statement_timestamp();
      ELSE
        ts := (to_jsonb(NEW.*)->>ts_column)::timestamp with time zone;
        IF ts IS NULL OR ts = (to_jsonb(OLD.*)->>ts_column)::timestamp with time zone THEN
          ts := statement_timestamp();
        END IF;
      END IF;

      IF to_jsonb(NEW.*) = to_jsonb(OLD.*) THEN
        RETURN NEW;
      END IF;

      IF current_version < (NEW.log_data#>>'{h,-1,v}')::int THEN
        iterator := 0;
        FOR item in SELECT * FROM jsonb_array_elements(NEW.log_data->'h')
        LOOP
          IF (item.value->>'v')::int > current_version THEN
            NEW.log_data := jsonb_set(
              NEW.log_data,
              '{h}',
              (NEW.log_data->'h') - iterator
            );
          END IF;
          iterator := iterator + 1;
        END LOOP;
      END IF;

      changes := '{}';

      IF (coalesce(current_setting('logidze.full_snapshot', true), '') = 'on') THEN
        BEGIN
          changes = hstore_to_jsonb_loose(hstore(NEW.*));
        EXCEPTION
          WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
            changes = row_to_json(NEW.*)::jsonb;
            FOR k IN (SELECT key FROM jsonb_each(changes))
            LOOP
              IF jsonb_typeof(changes->k) = 'object' THEN
                changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
              END IF;
            END LOOP;
        END;
      ELSE
        BEGIN
          changes = hstore_to_jsonb_loose(
                hstore(NEW.*) - hstore(OLD.*)
            );
        EXCEPTION
          WHEN NUMERIC_VALUE_OUT_OF_RANGE THEN
            changes = (SELECT
              COALESCE(json_object_agg(key, value), '{}')::jsonb
              FROM
              jsonb_each(row_to_json(NEW.*)::jsonb)
              WHERE NOT jsonb_build_object(key, value) <@ row_to_json(OLD.*)::jsonb);
            FOR k IN (SELECT key FROM jsonb_each(changes))
            LOOP
              IF jsonb_typeof(changes->k) = 'object' THEN
                changes = jsonb_set(changes, ARRAY[k], to_jsonb(changes->>k));
              END IF;
            END LOOP;
        END;
      END IF;

      changes = changes - 'log_data';

      IF columns IS NOT NULL THEN
        changes = logidze_filter_keys(changes, columns, include_columns);
      END IF;

      IF changes = '{}' THEN
        RETURN NEW;
      END IF;

      new_v := (NEW.log_data#>>'{h,-1,v}')::int + 1;

      size := jsonb_array_length(NEW.log_data->'h');
      version := logidze_version(new_v, changes, ts);

      IF (
        debounce_time IS NOT NULL AND
        (version->>'ts')::bigint - (NEW.log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
      ) THEN
        -- merge new version with the previous one
        new_v := (NEW.log_data#>>'{h,-1,v}')::int;
        version := logidze_version(new_v, (NEW.log_data#>'{h,-1,c}')::jsonb || changes, ts);
        -- remove the previous version from log
        NEW.log_data := jsonb_set(
          NEW.log_data,
          '{h}',
          (NEW.log_data->'h') - (size - 1)
        );
      END IF;

      NEW.log_data := jsonb_set(
        NEW.log_data,
        ARRAY['h', size::text],
        version,
        true
      );

      NEW.log_data := jsonb_set(
        NEW.log_data,
        '{v}',
        to_jsonb(new_v)
      );

      IF history_limit IS NOT NULL AND history_limit <= size THEN
        NEW.log_data := logidze_compact_history(NEW.log_data, size - history_limit + 1);
      END IF;
    END IF;

    return NEW;
  EXCEPTION
    WHEN OTHERS THEN
      GET STACKED DIAGNOSTICS err_sqlstate = RETURNED_SQLSTATE,
                              err_message = MESSAGE_TEXT,
                              err_detail = PG_EXCEPTION_DETAIL,
                              err_hint = PG_EXCEPTION_HINT,
                              err_context = PG_EXCEPTION_CONTEXT,
                              err_schema_name = SCHEMA_NAME,
                              err_table_name = TABLE_NAME;
      err_jsonb := jsonb_build_object(
        'returned_sqlstate', err_sqlstate,
        'message_text', err_message,
        'pg_exception_detail', err_detail,
        'pg_exception_hint', err_hint,
        'pg_exception_context', err_context,
        'schema_name', err_schema_name,
        'table_name', err_table_name
      );
      err_captured = logidze_capture_exception(err_jsonb);
      IF err_captured THEN
        return NEW;
      ELSE
        RAISE;
      END IF;
  END;
$$;


--
-- Name: logidze_snapshot(jsonb, text, text[], boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_snapshot(item jsonb, ts_column text DEFAULT NULL::text, columns text[] DEFAULT NULL::text[], include_columns boolean DEFAULT false) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  -- version: 3
  DECLARE
    ts timestamp with time zone;
    k text;
  BEGIN
    item = item - 'log_data';
    IF ts_column IS NULL THEN
      ts := statement_timestamp();
    ELSE
      ts := coalesce((item->>ts_column)::timestamp with time zone, statement_timestamp());
    END IF;

    IF columns IS NOT NULL THEN
      item := logidze_filter_keys(item, columns, include_columns);
    END IF;

    FOR k IN (SELECT key FROM jsonb_each(item))
    LOOP
      IF jsonb_typeof(item->k) = 'object' THEN
         item := jsonb_set(item, ARRAY[k], to_jsonb(item->>k));
      END IF;
    END LOOP;

    return json_build_object(
      'v', 1,
      'h', jsonb_build_array(
              logidze_version(1, item, ts)
            )
      );
  END;
$$;


--
-- Name: logidze_version(bigint, jsonb, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.logidze_version(v bigint, data jsonb, ts timestamp with time zone) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
  -- version: 2
  DECLARE
    buf jsonb;
  BEGIN
    data = data - 'log_data';
    buf := jsonb_build_object(
              'ts',
              (extract(epoch from ts) * 1000)::bigint,
              'v',
              v,
              'c',
              data
              );
    IF coalesce(current_setting('logidze.meta', true), '') <> '' THEN
      buf := jsonb_insert(buf, '{m}', current_setting('logidze.meta')::jsonb);
    END IF;
    RETURN buf;
  END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: market_order_snapshots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_order_snapshots (
    source_id smallint NOT NULL,
    esi_etag text,
    esi_expires_at timestamp without time zone,
    esi_last_modified_at timestamp without time zone,
    failed_at timestamp without time zone,
    fetched_at timestamp without time zone,
    fetching_at timestamp without time zone,
    skipped_at timestamp without time zone,
    status public.market_order_snapshot_status NOT NULL,
    status_exception jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: market_orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_orders (
    system_id bigint NOT NULL,
    source_id smallint NOT NULL,
    type_id bigint NOT NULL,
    duration smallint NOT NULL,
    is_buy_order boolean NOT NULL,
    issued timestamp(6) without time zone NOT NULL,
    location_id bigint NOT NULL,
    min_volume integer NOT NULL,
    order_id bigint NOT NULL,
    price numeric NOT NULL,
    range public.market_order_range NOT NULL,
    created_at timestamp without time zone NOT NULL,
    volume_remain integer NOT NULL,
    volume_total integer NOT NULL
);


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id uuid NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    name text NOT NULL
);


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    byte_size bigint NOT NULL,
    checksum text,
    content_type text,
    created_at timestamp(6) without time zone NOT NULL,
    filename text NOT NULL,
    key text NOT NULL,
    metadata text,
    service_name text NOT NULL
);


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    blob_id uuid NOT NULL,
    variation_digest text NOT NULL
);


--
-- Name: alliances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alliances (
    id bigint NOT NULL,
    creator_corporation_id bigint NOT NULL,
    creator_id bigint NOT NULL,
    executor_corporation_id bigint,
    faction_id bigint,
    esi_etag text NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    founded_on date NOT NULL,
    name text NOT NULL,
    ticker text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: alliances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alliances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alliances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alliances_id_seq OWNED BY public.alliances.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: bloodlines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bloodlines (
    id bigint NOT NULL,
    corporation_id bigint NOT NULL,
    icon_id bigint,
    race_id bigint NOT NULL,
    charisma integer NOT NULL,
    description text NOT NULL,
    intelligence integer NOT NULL,
    memory integer NOT NULL,
    name text NOT NULL,
    perception integer NOT NULL,
    willpower integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: bloodlines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bloodlines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bloodlines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bloodlines_id_seq OWNED BY public.bloodlines.id;


--
-- Name: blueprint_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activities (
    blueprint_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    "time" interval NOT NULL,
    log_data jsonb
);


--
-- Name: blueprint_activity_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_materials (
    blueprint_id bigint NOT NULL,
    material_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    quantity integer NOT NULL,
    log_data jsonb
);


--
-- Name: blueprint_activity_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_products (
    blueprint_id bigint NOT NULL,
    product_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    quantity integer NOT NULL,
    probability numeric,
    log_data jsonb
);


--
-- Name: blueprint_activity_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_skills (
    blueprint_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    level integer NOT NULL,
    log_data jsonb
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    icon_id bigint,
    name text NOT NULL,
    published boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: celestials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.celestials (
    id bigint NOT NULL,
    effect_beacon_type_id bigint,
    height_map_1_id bigint,
    height_map_2_id bigint,
    shader_preset_id bigint,
    solar_system_id bigint NOT NULL,
    type_id bigint NOT NULL,
    age numeric,
    ancestry text,
    celestial_index integer,
    celestial_type text NOT NULL,
    density numeric,
    eccentricity numeric,
    escape_velocity numeric,
    fragmented boolean,
    life numeric,
    locked boolean,
    luminosity numeric,
    mass_dust numeric,
    mass_gas numeric,
    orbit_period numeric,
    orbit_radius numeric,
    name text NOT NULL,
    population boolean,
    position_x numeric NOT NULL,
    position_y numeric NOT NULL,
    position_z numeric NOT NULL,
    pressure numeric,
    radius numeric,
    rotation_rate numeric,
    spectral_class text,
    surface_gravity numeric,
    temperature numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: celestials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.celestials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: celestials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.celestials_id_seq OWNED BY public.celestials.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.characters (
    id bigint NOT NULL,
    bloodline_id bigint NOT NULL,
    corporation_id bigint NOT NULL,
    faction_id bigint,
    race_id bigint NOT NULL,
    birthday date NOT NULL,
    description text,
    esi_etag text NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    gender text NOT NULL,
    name text NOT NULL,
    owner_hash text,
    security_status numeric,
    title text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: constellations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.constellations (
    id bigint NOT NULL,
    region_id bigint NOT NULL,
    center_x numeric NOT NULL,
    center_y numeric NOT NULL,
    center_z numeric NOT NULL,
    max_x numeric NOT NULL,
    max_y numeric NOT NULL,
    max_z numeric NOT NULL,
    min_x numeric NOT NULL,
    min_y numeric NOT NULL,
    min_z numeric NOT NULL,
    radius numeric NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    faction_id bigint,
    wormhole_class_id bigint,
    log_data jsonb
);


--
-- Name: constellations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.constellations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: constellations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.constellations_id_seq OWNED BY public.constellations.id;


--
-- Name: corporations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.corporations (
    id bigint NOT NULL,
    alliance_id bigint,
    ceo_id bigint,
    creator_id bigint,
    faction_id bigint,
    home_station_id bigint,
    description text,
    esi_etag text,
    esi_expires_at timestamp without time zone,
    esi_last_modified_at timestamp without time zone,
    founded_on date,
    member_count integer,
    name text NOT NULL,
    share_count bigint,
    tax_rate numeric NOT NULL,
    ticker text NOT NULL,
    url text,
    war_eligible boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    enemy_id bigint,
    friend_id bigint,
    icon_id bigint,
    main_activity_id bigint,
    race_id bigint,
    secondary_activity_id bigint,
    solar_system_id bigint,
    deleted boolean,
    extent text,
    npc boolean,
    size_factor numeric,
    size text,
    log_data jsonb
);


--
-- Name: corporations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.corporations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: corporations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.corporations_id_seq OWNED BY public.corporations.id;


--
-- Name: dogma_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dogma_attributes (
    id bigint NOT NULL,
    category_id bigint,
    recharge_time_attribute_id bigint,
    data_type_id bigint,
    icon_id bigint,
    max_attribute_id bigint,
    unit_id bigint,
    default_value numeric NOT NULL,
    description text,
    display_name text,
    display_when_zero boolean,
    high_is_good boolean NOT NULL,
    name text NOT NULL,
    published boolean NOT NULL,
    stackable boolean NOT NULL,
    tooltip_description text,
    tooltip_title text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: dogma_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dogma_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dogma_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dogma_attributes_id_seq OWNED BY public.dogma_attributes.id;


--
-- Name: dogma_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dogma_categories (
    id bigint NOT NULL,
    description text,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: dogma_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dogma_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dogma_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dogma_categories_id_seq OWNED BY public.dogma_categories.id;


--
-- Name: dogma_effects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dogma_effects (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    discharge_attribute_id bigint,
    duration_attribute_id bigint,
    falloff_attribute_id bigint,
    fitting_usage_chance_attribute_id bigint,
    icon_id bigint,
    npc_activation_chance_attribute_id bigint,
    npc_usage_chance_attribute_id bigint,
    range_attribute_id bigint,
    resistance_attribute_id bigint,
    tracking_speed_attribute_id bigint,
    description text,
    disallow_auto_repeat boolean NOT NULL,
    display_name text,
    distribution integer,
    electronic_chance boolean NOT NULL,
    guid text,
    is_assistance boolean NOT NULL,
    is_offensive boolean NOT NULL,
    is_warp_safe boolean NOT NULL,
    name text NOT NULL,
    propulsion_chance boolean NOT NULL,
    published boolean NOT NULL,
    range_chance boolean NOT NULL,
    sfx_name text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb,
    modifiers jsonb
);


--
-- Name: dogma_effects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dogma_effects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dogma_effects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dogma_effects_id_seq OWNED BY public.dogma_effects.id;


--
-- Name: esi_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.esi_tokens (
    id bigint NOT NULL,
    identity_id bigint NOT NULL,
    requester_id bigint NOT NULL,
    access_token text,
    approved_at timestamp(6) without time zone,
    authorized_at timestamp(6) without time zone,
    refresh_error_code text,
    refresh_error_description text,
    refresh_error_status integer,
    refresh_token text,
    refreshed_at timestamp(6) without time zone,
    rejected_at timestamp(6) without time zone,
    revoked_at timestamp(6) without time zone,
    expired_at timestamp(6) without time zone,
    expires_at timestamp(6) without time zone,
    scopes text[] NOT NULL,
    status public.esi_token_status NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    resource_type character varying,
    resource_id bigint,
    grant_type text,
    used_at timestamp without time zone
);


--
-- Name: esi_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.esi_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: esi_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.esi_tokens_id_seq OWNED BY public.esi_tokens.id;


--
-- Name: faction_races; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faction_races (
    faction_id bigint NOT NULL,
    race_id bigint NOT NULL,
    log_data jsonb
);


--
-- Name: factions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.factions (
    id bigint NOT NULL,
    corporation_id bigint,
    icon_id bigint NOT NULL,
    militia_corporation_id bigint,
    solar_system_id bigint NOT NULL,
    description text NOT NULL,
    name text NOT NULL,
    short_description text,
    size_factor numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: factions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.factions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: factions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.factions_id_seq OWNED BY public.factions.id;


--
-- Name: graphics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.graphics (
    id bigint NOT NULL,
    description text,
    graphic_file text,
    icon_folder text,
    skin_faction_name text,
    skin_hull_name text,
    skin_race_name text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: graphics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.graphics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: graphics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.graphics_id_seq OWNED BY public.graphics.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    icon_id bigint,
    anchorable boolean NOT NULL,
    anchored boolean NOT NULL,
    fittable_non_singleton boolean NOT NULL,
    name text NOT NULL,
    published boolean NOT NULL,
    use_base_price boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: icons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.icons (
    id bigint NOT NULL,
    description text,
    file text NOT NULL,
    obsolete boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: icons_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.icons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: icons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.icons_id_seq OWNED BY public.icons.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id bigint NOT NULL,
    character_id bigint NOT NULL,
    user_id bigint NOT NULL,
    "default" boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: inventory_flags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inventory_flags (
    id bigint NOT NULL,
    name text NOT NULL,
    "order" integer NOT NULL,
    text text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: inventory_flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inventory_flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inventory_flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inventory_flags_id_seq OWNED BY public.inventory_flags.id;


--
-- Name: login_activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_activities (
    id bigint NOT NULL,
    user_type character varying,
    user_id bigint,
    context text,
    created_at timestamp(6) without time zone NOT NULL,
    failure_reason text,
    identity text,
    ip text,
    referrer text,
    scope text,
    strategy text,
    success boolean,
    user_agent text
);


--
-- Name: login_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.login_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.login_activities_id_seq OWNED BY public.login_activities.id;


--
-- Name: login_permits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.login_permits (
    id bigint NOT NULL,
    permittable_type text NOT NULL,
    permittable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    name text NOT NULL
);


--
-- Name: login_permits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.login_permits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: login_permits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.login_permits_id_seq OWNED BY public.login_permits.id;


--
-- Name: market_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_groups (
    id bigint NOT NULL,
    icon_id bigint,
    ancestry text,
    ancestry_depth integer DEFAULT 0 NOT NULL,
    description text,
    has_types boolean NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: market_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.market_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.market_groups_id_seq OWNED BY public.market_groups.id;


--
-- Name: market_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_locations (
    location_type character varying NOT NULL,
    location_id bigint NOT NULL,
    market_id smallint NOT NULL
);


--
-- Name: market_order_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_order_sources (
    id smallint NOT NULL,
    source_type character varying NOT NULL,
    source_id bigint NOT NULL,
    disabled_at timestamp without time zone,
    expires_at timestamp without time zone,
    fetching_at timestamp without time zone,
    fetched_at timestamp without time zone,
    fetching_failed_at timestamp without time zone,
    name text NOT NULL,
    pending_at timestamp without time zone,
    status public.market_order_source_status NOT NULL,
    status_exception jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: market_order_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.market_order_sources_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_order_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.market_order_sources_id_seq OWNED BY public.market_order_sources.id;


--
-- Name: market_sources; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.market_sources (
    market_id smallint NOT NULL,
    source_id smallint NOT NULL
);


--
-- Name: markets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.markets (
    id smallint NOT NULL,
    aggregating_at timestamp without time zone,
    aggregating_failed_at timestamp without time zone,
    aggregated_at timestamp without time zone,
    disabled_at timestamp without time zone,
    expires_at timestamp without time zone,
    hub boolean,
    regional boolean,
    name text NOT NULL,
    description text,
    pending_at timestamp without time zone,
    slug text NOT NULL,
    status public.market_status NOT NULL,
    status_exception jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: markets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.markets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: markets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.markets_id_seq OWNED BY public.markets.id;


--
-- Name: meta_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meta_groups (
    id bigint NOT NULL,
    icon_id bigint,
    description text,
    icon_suffix text,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: meta_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.meta_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: meta_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.meta_groups_id_seq OWNED BY public.meta_groups.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pg_search_documents (
    id bigint NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pg_search_documents_id_seq OWNED BY public.pg_search_documents.id;


--
-- Name: planet_schematic_inputs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.planet_schematic_inputs (
    schematic_id bigint NOT NULL,
    type_id bigint NOT NULL,
    quantity integer NOT NULL,
    log_data jsonb
);


--
-- Name: planet_schematic_pins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.planet_schematic_pins (
    schematic_id bigint NOT NULL,
    type_id bigint NOT NULL,
    log_data jsonb
);


--
-- Name: planet_schematics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.planet_schematics (
    id bigint NOT NULL,
    output_id bigint NOT NULL,
    "time" interval NOT NULL,
    name text NOT NULL,
    output_quantity integer NOT NULL,
    pins integer[] NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: planet_schematics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.planet_schematics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: planet_schematics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.planet_schematics_id_seq OWNED BY public.planet_schematics.id;


--
-- Name: races; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.races (
    id bigint NOT NULL,
    icon_id bigint,
    ship_type_id bigint,
    description text,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: races_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.races_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: races_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.races_id_seq OWNED BY public.races.id;


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    faction_id bigint,
    nebula_id bigint,
    wormhole_class_id bigint,
    center_x numeric NOT NULL,
    center_y numeric NOT NULL,
    center_z numeric NOT NULL,
    description text,
    max_x numeric NOT NULL,
    max_y numeric NOT NULL,
    max_z numeric NOT NULL,
    min_x numeric NOT NULL,
    min_y numeric NOT NULL,
    min_z numeric NOT NULL,
    name text NOT NULL,
    universe public.universe NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: solar_systems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solar_systems (
    id bigint NOT NULL,
    constellation_id bigint NOT NULL,
    faction_id bigint,
    wormhole_class_id bigint,
    border boolean NOT NULL,
    center_x numeric NOT NULL,
    center_y numeric NOT NULL,
    center_z numeric NOT NULL,
    corridor boolean NOT NULL,
    disallowed_anchor_categories integer[],
    disallowed_anchor_groups integer[],
    fringe boolean NOT NULL,
    hub boolean NOT NULL,
    international boolean NOT NULL,
    luminosity numeric NOT NULL,
    max_x numeric NOT NULL,
    max_y numeric NOT NULL,
    max_z numeric NOT NULL,
    min_x numeric NOT NULL,
    min_y numeric NOT NULL,
    min_z numeric NOT NULL,
    radius numeric NOT NULL,
    regional boolean NOT NULL,
    security numeric NOT NULL,
    security_class text,
    name text NOT NULL,
    visual_effect text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: solar_systems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solar_systems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: solar_systems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solar_systems_id_seq OWNED BY public.solar_systems.id;


--
-- Name: stargates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stargates (
    id bigint NOT NULL,
    destination_id bigint NOT NULL,
    solar_system_id bigint NOT NULL,
    type_id bigint NOT NULL,
    name text NOT NULL,
    position_x numeric NOT NULL,
    position_y numeric NOT NULL,
    position_z numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: stargates_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stargates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stargates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stargates_id_seq OWNED BY public.stargates.id;


--
-- Name: static_data_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.static_data_versions (
    id bigint NOT NULL,
    checksum text NOT NULL,
    current boolean,
    downloaded_at timestamp(6) without time zone,
    downloading_at timestamp(6) without time zone,
    downloading_failed_at timestamp(6) without time zone,
    imported_at timestamp(6) without time zone,
    importing_at timestamp(6) without time zone,
    importing_failed_at timestamp(6) without time zone,
    status public.static_data_version_status NOT NULL,
    status_exception jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb,
    status_log text[]
);


--
-- Name: static_data_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.static_data_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: static_data_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.static_data_versions_id_seq OWNED BY public.static_data_versions.id;


--
-- Name: station_operation_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.station_operation_services (
    operation_id bigint NOT NULL,
    service_id bigint NOT NULL,
    log_data jsonb
);


--
-- Name: station_operation_station_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.station_operation_station_types (
    operation_id bigint NOT NULL,
    race_id bigint NOT NULL,
    type_id bigint NOT NULL,
    log_data jsonb
);


--
-- Name: station_operations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.station_operations (
    id bigint NOT NULL,
    activity_id bigint NOT NULL,
    border boolean NOT NULL,
    corridor boolean NOT NULL,
    description text,
    fringe boolean NOT NULL,
    hub boolean NOT NULL,
    manufacturing_factor numeric NOT NULL,
    name text NOT NULL,
    ratio numeric NOT NULL,
    research_factor numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: station_operations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.station_operations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: station_operations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.station_operations_id_seq OWNED BY public.station_operations.id;


--
-- Name: station_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.station_services (
    id bigint NOT NULL,
    description text,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: station_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.station_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: station_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.station_services_id_seq OWNED BY public.station_services.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stations (
    id bigint NOT NULL,
    celestial_id bigint NOT NULL,
    corporation_id bigint NOT NULL,
    graphic_id bigint NOT NULL,
    operation_id bigint NOT NULL,
    reprocessing_hangar_flag_id bigint NOT NULL,
    type_id bigint NOT NULL,
    conquerable boolean NOT NULL,
    docking_cost_per_volume numeric NOT NULL,
    max_ship_volume_dockable numeric NOT NULL,
    name text NOT NULL,
    office_rental_cost numeric NOT NULL,
    position_x numeric NOT NULL,
    position_y numeric NOT NULL,
    position_z numeric NOT NULL,
    reprocessing_efficiency numeric NOT NULL,
    reprocessing_station_take numeric NOT NULL,
    use_operation_name boolean NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stations_id_seq OWNED BY public.stations.id;


--
-- Name: structures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.structures (
    id bigint NOT NULL,
    corporation_id bigint NOT NULL,
    solar_system_id bigint NOT NULL,
    type_id bigint,
    discarded_at timestamp(6) without time zone,
    esi_etag text NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    log_data jsonb,
    name text NOT NULL,
    position_x numeric NOT NULL,
    position_y numeric NOT NULL,
    position_z numeric NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: structures_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.structures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.structures_id_seq OWNED BY public.structures.id;


--
-- Name: type_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_materials (
    type_id bigint NOT NULL,
    material_id bigint NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);


--
-- Name: types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.types (
    id bigint NOT NULL,
    faction_id bigint,
    graphic_id bigint,
    group_id bigint NOT NULL,
    icon_id bigint,
    market_group_id bigint,
    meta_group_id bigint,
    race_id bigint,
    skin_material_set_id bigint,
    sound_id bigint,
    variation_parent_type_id bigint,
    base_price numeric,
    capacity numeric,
    description text,
    mass numeric,
    name text NOT NULL,
    packaged_volume numeric,
    portion_size integer NOT NULL,
    published boolean NOT NULL,
    radius numeric,
    skin_faction_name text,
    volume numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    max_production_limit integer,
    dogma_attributes jsonb,
    dogma_effects jsonb,
    traits jsonb,
    log_data jsonb
);


--
-- Name: types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.types_id_seq OWNED BY public.types.id;


--
-- Name: units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.units (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb,
    description text,
    display_name text
);


--
-- Name: units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.units_id_seq OWNED BY public.units.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    admin boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    event text NOT NULL,
    object jsonb,
    object_changes jsonb,
    whodunnit text
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: alliances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances ALTER COLUMN id SET DEFAULT nextval('public.alliances_id_seq'::regclass);


--
-- Name: bloodlines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bloodlines ALTER COLUMN id SET DEFAULT nextval('public.bloodlines_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: celestials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.celestials ALTER COLUMN id SET DEFAULT nextval('public.celestials_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: constellations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constellations ALTER COLUMN id SET DEFAULT nextval('public.constellations_id_seq'::regclass);


--
-- Name: corporations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations ALTER COLUMN id SET DEFAULT nextval('public.corporations_id_seq'::regclass);


--
-- Name: dogma_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_attributes ALTER COLUMN id SET DEFAULT nextval('public.dogma_attributes_id_seq'::regclass);


--
-- Name: dogma_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_categories ALTER COLUMN id SET DEFAULT nextval('public.dogma_categories_id_seq'::regclass);


--
-- Name: dogma_effects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_effects ALTER COLUMN id SET DEFAULT nextval('public.dogma_effects_id_seq'::regclass);


--
-- Name: esi_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_tokens ALTER COLUMN id SET DEFAULT nextval('public.esi_tokens_id_seq'::regclass);


--
-- Name: factions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.factions ALTER COLUMN id SET DEFAULT nextval('public.factions_id_seq'::regclass);


--
-- Name: graphics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.graphics ALTER COLUMN id SET DEFAULT nextval('public.graphics_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: icons id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.icons ALTER COLUMN id SET DEFAULT nextval('public.icons_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: inventory_flags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_flags ALTER COLUMN id SET DEFAULT nextval('public.inventory_flags_id_seq'::regclass);


--
-- Name: login_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_activities ALTER COLUMN id SET DEFAULT nextval('public.login_activities_id_seq'::regclass);


--
-- Name: login_permits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_permits ALTER COLUMN id SET DEFAULT nextval('public.login_permits_id_seq'::regclass);


--
-- Name: market_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_groups ALTER COLUMN id SET DEFAULT nextval('public.market_groups_id_seq'::regclass);


--
-- Name: market_order_sources id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_order_sources ALTER COLUMN id SET DEFAULT nextval('public.market_order_sources_id_seq'::regclass);


--
-- Name: markets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.markets ALTER COLUMN id SET DEFAULT nextval('public.markets_id_seq'::regclass);


--
-- Name: meta_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_groups ALTER COLUMN id SET DEFAULT nextval('public.meta_groups_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents ALTER COLUMN id SET DEFAULT nextval('public.pg_search_documents_id_seq'::regclass);


--
-- Name: planet_schematics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.planet_schematics ALTER COLUMN id SET DEFAULT nextval('public.planet_schematics_id_seq'::regclass);


--
-- Name: races id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.races ALTER COLUMN id SET DEFAULT nextval('public.races_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: solar_systems id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solar_systems ALTER COLUMN id SET DEFAULT nextval('public.solar_systems_id_seq'::regclass);


--
-- Name: stargates id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stargates ALTER COLUMN id SET DEFAULT nextval('public.stargates_id_seq'::regclass);


--
-- Name: static_data_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_versions ALTER COLUMN id SET DEFAULT nextval('public.static_data_versions_id_seq'::regclass);


--
-- Name: station_operations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.station_operations ALTER COLUMN id SET DEFAULT nextval('public.station_operations_id_seq'::regclass);


--
-- Name: station_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.station_services ALTER COLUMN id SET DEFAULT nextval('public.station_services_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations ALTER COLUMN id SET DEFAULT nextval('public.stations_id_seq'::regclass);


--
-- Name: structures id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures ALTER COLUMN id SET DEFAULT nextval('public.structures_id_seq'::regclass);


--
-- Name: types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types ALTER COLUMN id SET DEFAULT nextval('public.types_id_seq'::regclass);


--
-- Name: units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.units ALTER COLUMN id SET DEFAULT nextval('public.units_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: alliances alliances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alliances
    ADD CONSTRAINT alliances_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: bloodlines bloodlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bloodlines
    ADD CONSTRAINT bloodlines_pkey PRIMARY KEY (id);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: celestials celestials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.celestials
    ADD CONSTRAINT celestials_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: constellations constellations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.constellations
    ADD CONSTRAINT constellations_pkey PRIMARY KEY (id);


--
-- Name: corporations corporations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations
    ADD CONSTRAINT corporations_pkey PRIMARY KEY (id);


--
-- Name: dogma_attributes dogma_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_attributes
    ADD CONSTRAINT dogma_attributes_pkey PRIMARY KEY (id);


--
-- Name: dogma_categories dogma_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_categories
    ADD CONSTRAINT dogma_categories_pkey PRIMARY KEY (id);


--
-- Name: dogma_effects dogma_effects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_effects
    ADD CONSTRAINT dogma_effects_pkey PRIMARY KEY (id);


--
-- Name: esi_tokens esi_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_tokens
    ADD CONSTRAINT esi_tokens_pkey PRIMARY KEY (id);


--
-- Name: factions factions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.factions
    ADD CONSTRAINT factions_pkey PRIMARY KEY (id);


--
-- Name: graphics graphics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.graphics
    ADD CONSTRAINT graphics_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: icons icons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.icons
    ADD CONSTRAINT icons_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: inventory_flags inventory_flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inventory_flags
    ADD CONSTRAINT inventory_flags_pkey PRIMARY KEY (id);


--
-- Name: login_activities login_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_activities
    ADD CONSTRAINT login_activities_pkey PRIMARY KEY (id);


--
-- Name: login_permits login_permits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.login_permits
    ADD CONSTRAINT login_permits_pkey PRIMARY KEY (id);


--
-- Name: market_groups market_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_groups
    ADD CONSTRAINT market_groups_pkey PRIMARY KEY (id);


--
-- Name: market_order_sources market_order_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_order_sources
    ADD CONSTRAINT market_order_sources_pkey PRIMARY KEY (id);


--
-- Name: markets markets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.markets
    ADD CONSTRAINT markets_pkey PRIMARY KEY (id);


--
-- Name: meta_groups meta_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_groups
    ADD CONSTRAINT meta_groups_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: planet_schematics planet_schematics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.planet_schematics
    ADD CONSTRAINT planet_schematics_pkey PRIMARY KEY (id);


--
-- Name: races races_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.races
    ADD CONSTRAINT races_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: solar_systems solar_systems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solar_systems
    ADD CONSTRAINT solar_systems_pkey PRIMARY KEY (id);


--
-- Name: stargates stargates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stargates
    ADD CONSTRAINT stargates_pkey PRIMARY KEY (id);


--
-- Name: static_data_versions static_data_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_versions
    ADD CONSTRAINT static_data_versions_pkey PRIMARY KEY (id);


--
-- Name: station_operations station_operations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.station_operations
    ADD CONSTRAINT station_operations_pkey PRIMARY KEY (id);


--
-- Name: station_services station_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.station_services
    ADD CONSTRAINT station_services_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: structures structures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT structures_pkey PRIMARY KEY (id);


--
-- Name: types types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.types
    ADD CONSTRAINT types_pkey PRIMARY KEY (id);


--
-- Name: units units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.units
    ADD CONSTRAINT units_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_alliances_on_creator_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_creator_corporation_id ON public.alliances USING btree (creator_corporation_id);


--
-- Name: index_alliances_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_creator_id ON public.alliances USING btree (creator_id);


--
-- Name: index_alliances_on_executor_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_executor_corporation_id ON public.alliances USING btree (executor_corporation_id);


--
-- Name: index_alliances_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alliances_on_faction_id ON public.alliances USING btree (faction_id);


--
-- Name: index_bloodlines_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bloodlines_on_corporation_id ON public.bloodlines USING btree (corporation_id);


--
-- Name: index_bloodlines_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bloodlines_on_icon_id ON public.bloodlines USING btree (icon_id);


--
-- Name: index_bloodlines_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bloodlines_on_race_id ON public.bloodlines USING btree (race_id);


--
-- Name: index_blueprint_activity_materials_on_material_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_materials_on_material_id ON public.blueprint_activity_materials USING btree (material_id);


--
-- Name: index_blueprint_activity_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_products_on_product_id ON public.blueprint_activity_products USING btree (product_id);


--
-- Name: index_blueprint_activity_skills_on_skill_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_skills_on_skill_id ON public.blueprint_activity_skills USING btree (skill_id);


--
-- Name: index_categories_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_on_icon_id ON public.categories USING btree (icon_id);


--
-- Name: index_celestials_on_effect_beacon_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_effect_beacon_type_id ON public.celestials USING btree (effect_beacon_type_id);


--
-- Name: index_celestials_on_height_map_1_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_height_map_1_id ON public.celestials USING btree (height_map_1_id);


--
-- Name: index_celestials_on_height_map_2_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_height_map_2_id ON public.celestials USING btree (height_map_2_id);


--
-- Name: index_celestials_on_shader_preset_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_shader_preset_id ON public.celestials USING btree (shader_preset_id);


--
-- Name: index_celestials_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_solar_system_id ON public.celestials USING btree (solar_system_id);


--
-- Name: index_celestials_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_celestials_on_type_id ON public.celestials USING btree (type_id);


--
-- Name: index_characters_on_bloodline_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_bloodline_id ON public.characters USING btree (bloodline_id);


--
-- Name: index_characters_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_corporation_id ON public.characters USING btree (corporation_id);


--
-- Name: index_characters_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_faction_id ON public.characters USING btree (faction_id);


--
-- Name: index_characters_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_characters_on_race_id ON public.characters USING btree (race_id);


--
-- Name: index_constellations_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_constellations_on_faction_id ON public.constellations USING btree (faction_id);


--
-- Name: index_constellations_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_constellations_on_region_id ON public.constellations USING btree (region_id);


--
-- Name: index_constellations_on_wormhole_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_constellations_on_wormhole_class_id ON public.constellations USING btree (wormhole_class_id);


--
-- Name: index_corporations_on_alliance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_alliance_id ON public.corporations USING btree (alliance_id);


--
-- Name: index_corporations_on_ceo_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_ceo_id ON public.corporations USING btree (ceo_id);


--
-- Name: index_corporations_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_creator_id ON public.corporations USING btree (creator_id);


--
-- Name: index_corporations_on_enemy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_enemy_id ON public.corporations USING btree (enemy_id);


--
-- Name: index_corporations_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_faction_id ON public.corporations USING btree (faction_id);


--
-- Name: index_corporations_on_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_friend_id ON public.corporations USING btree (friend_id);


--
-- Name: index_corporations_on_home_station_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_home_station_id ON public.corporations USING btree (home_station_id);


--
-- Name: index_corporations_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_icon_id ON public.corporations USING btree (icon_id);


--
-- Name: index_corporations_on_main_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_main_activity_id ON public.corporations USING btree (main_activity_id);


--
-- Name: index_corporations_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_race_id ON public.corporations USING btree (race_id);


--
-- Name: index_corporations_on_secondary_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_secondary_activity_id ON public.corporations USING btree (secondary_activity_id);


--
-- Name: index_corporations_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_solar_system_id ON public.corporations USING btree (solar_system_id);


--
-- Name: index_dogma_attributes_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_category_id ON public.dogma_attributes USING btree (category_id);


--
-- Name: index_dogma_attributes_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_data_type_id ON public.dogma_attributes USING btree (data_type_id);


--
-- Name: index_dogma_attributes_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_icon_id ON public.dogma_attributes USING btree (icon_id);


--
-- Name: index_dogma_attributes_on_max_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_max_attribute_id ON public.dogma_attributes USING btree (max_attribute_id);


--
-- Name: index_dogma_attributes_on_recharge_time_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_recharge_time_attribute_id ON public.dogma_attributes USING btree (recharge_time_attribute_id);


--
-- Name: index_dogma_attributes_on_unit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_attributes_on_unit_id ON public.dogma_attributes USING btree (unit_id);


--
-- Name: index_dogma_effects_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_category_id ON public.dogma_effects USING btree (category_id);


--
-- Name: index_dogma_effects_on_discharge_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_discharge_attribute_id ON public.dogma_effects USING btree (discharge_attribute_id);


--
-- Name: index_dogma_effects_on_duration_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_duration_attribute_id ON public.dogma_effects USING btree (duration_attribute_id);


--
-- Name: index_dogma_effects_on_falloff_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_falloff_attribute_id ON public.dogma_effects USING btree (falloff_attribute_id);


--
-- Name: index_dogma_effects_on_fitting_usage_chance_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_fitting_usage_chance_attribute_id ON public.dogma_effects USING btree (fitting_usage_chance_attribute_id);


--
-- Name: index_dogma_effects_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_icon_id ON public.dogma_effects USING btree (icon_id);


--
-- Name: index_dogma_effects_on_npc_activation_chance_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_npc_activation_chance_attribute_id ON public.dogma_effects USING btree (npc_activation_chance_attribute_id);


--
-- Name: index_dogma_effects_on_npc_usage_chance_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_npc_usage_chance_attribute_id ON public.dogma_effects USING btree (npc_usage_chance_attribute_id);


--
-- Name: index_dogma_effects_on_range_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_range_attribute_id ON public.dogma_effects USING btree (range_attribute_id);


--
-- Name: index_dogma_effects_on_resistance_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_resistance_attribute_id ON public.dogma_effects USING btree (resistance_attribute_id);


--
-- Name: index_dogma_effects_on_tracking_speed_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effects_on_tracking_speed_attribute_id ON public.dogma_effects USING btree (tracking_speed_attribute_id);


--
-- Name: index_esi_tokens_on_identity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_esi_tokens_on_identity_id ON public.esi_tokens USING btree (identity_id);


--
-- Name: index_esi_tokens_on_requester_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_esi_tokens_on_requester_id ON public.esi_tokens USING btree (requester_id);


--
-- Name: index_esi_tokens_with_resources; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_esi_tokens_with_resources ON public.esi_tokens USING btree (grant_type, resource_type, resource_id);


--
-- Name: index_faction_races_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_faction_races_on_race_id ON public.faction_races USING btree (race_id);


--
-- Name: index_factions_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factions_on_corporation_id ON public.factions USING btree (corporation_id);


--
-- Name: index_factions_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factions_on_icon_id ON public.factions USING btree (icon_id);


--
-- Name: index_factions_on_militia_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factions_on_militia_corporation_id ON public.factions USING btree (militia_corporation_id);


--
-- Name: index_factions_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_factions_on_solar_system_id ON public.factions USING btree (solar_system_id);


--
-- Name: index_groups_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_category_id ON public.groups USING btree (category_id);


--
-- Name: index_groups_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_groups_on_icon_id ON public.groups USING btree (icon_id);


--
-- Name: index_identities_on_character_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_identities_on_character_id ON public.identities USING btree (character_id);


--
-- Name: index_login_activities_on_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_identity ON public.login_activities USING btree (identity);


--
-- Name: index_login_activities_on_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_ip ON public.login_activities USING btree (ip);


--
-- Name: index_login_activities_on_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_activities_on_user ON public.login_activities USING btree (user_type, user_id);


--
-- Name: index_market_groups_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_groups_on_ancestry ON public.market_groups USING btree (ancestry);


--
-- Name: index_market_groups_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_groups_on_icon_id ON public.market_groups USING btree (icon_id);


--
-- Name: index_market_orders_on_order_type_and_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_orders_on_order_type_and_type ON public.market_orders USING btree (source_id, location_id, is_buy_order, type_id, created_at);


--
-- Name: index_meta_groups_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meta_groups_on_icon_id ON public.meta_groups USING btree (icon_id);


--
-- Name: index_pg_search_documents_on_searchable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable ON public.pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_planet_schematics_on_output_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_planet_schematics_on_output_id ON public.planet_schematics USING btree (output_id);


--
-- Name: index_races_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_races_on_icon_id ON public.races USING btree (icon_id);


--
-- Name: index_races_on_ship_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_races_on_ship_type_id ON public.races USING btree (ship_type_id);


--
-- Name: index_regions_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regions_on_faction_id ON public.regions USING btree (faction_id);


--
-- Name: index_regions_on_nebula_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regions_on_nebula_id ON public.regions USING btree (nebula_id);


--
-- Name: index_regions_on_wormhole_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regions_on_wormhole_class_id ON public.regions USING btree (wormhole_class_id);


--
-- Name: index_solar_systems_on_constellation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solar_systems_on_constellation_id ON public.solar_systems USING btree (constellation_id);


--
-- Name: index_solar_systems_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solar_systems_on_faction_id ON public.solar_systems USING btree (faction_id);


--
-- Name: index_solar_systems_on_wormhole_class_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solar_systems_on_wormhole_class_id ON public.solar_systems USING btree (wormhole_class_id);


--
-- Name: index_stargates_on_destination_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stargates_on_destination_id ON public.stargates USING btree (destination_id);


--
-- Name: index_stargates_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stargates_on_solar_system_id ON public.stargates USING btree (solar_system_id);


--
-- Name: index_stargates_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stargates_on_type_id ON public.stargates USING btree (type_id);


--
-- Name: index_static_data_versions_on_checksum; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_static_data_versions_on_checksum ON public.static_data_versions USING btree (checksum);


--
-- Name: index_static_data_versions_on_current; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_static_data_versions_on_current ON public.static_data_versions USING btree (current);


--
-- Name: index_station_operation_services_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_services_on_service_id ON public.station_operation_services USING btree (service_id);


--
-- Name: index_station_operation_station_types_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_station_types_on_race_id ON public.station_operation_station_types USING btree (race_id);


--
-- Name: index_station_operation_station_types_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_station_types_on_type_id ON public.station_operation_station_types USING btree (type_id);


--
-- Name: index_station_operations_on_activity_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operations_on_activity_id ON public.station_operations USING btree (activity_id);


--
-- Name: index_stations_on_celestial_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_celestial_id ON public.stations USING btree (celestial_id);


--
-- Name: index_stations_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_corporation_id ON public.stations USING btree (corporation_id);


--
-- Name: index_stations_on_graphic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_graphic_id ON public.stations USING btree (graphic_id);


--
-- Name: index_stations_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_operation_id ON public.stations USING btree (operation_id);


--
-- Name: index_stations_on_reprocessing_hangar_flag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_reprocessing_hangar_flag_id ON public.stations USING btree (reprocessing_hangar_flag_id);


--
-- Name: index_stations_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_type_id ON public.stations USING btree (type_id);


--
-- Name: index_structures_on_corporation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_corporation_id ON public.structures USING btree (corporation_id);


--
-- Name: index_structures_on_solar_system_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_solar_system_id ON public.structures USING btree (solar_system_id);


--
-- Name: index_structures_on_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_structures_on_type_id ON public.structures USING btree (type_id);


--
-- Name: index_types_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_faction_id ON public.types USING btree (faction_id);


--
-- Name: index_types_on_graphic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_graphic_id ON public.types USING btree (graphic_id);


--
-- Name: index_types_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_group_id ON public.types USING btree (group_id);


--
-- Name: index_types_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_icon_id ON public.types USING btree (icon_id);


--
-- Name: index_types_on_market_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_market_group_id ON public.types USING btree (market_group_id);


--
-- Name: index_types_on_meta_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_meta_group_id ON public.types USING btree (meta_group_id);


--
-- Name: index_types_on_race_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_race_id ON public.types USING btree (race_id);


--
-- Name: index_types_on_skin_material_set_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_skin_material_set_id ON public.types USING btree (skin_material_set_id);


--
-- Name: index_types_on_sound_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_sound_id ON public.types USING btree (sound_id);


--
-- Name: index_types_on_variation_parent_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_types_on_variation_parent_type_id ON public.types USING btree (variation_parent_type_id);


--
-- Name: index_unique_active_storage_attachments; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_active_storage_attachments ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_unique_active_storage_blobs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_active_storage_blobs ON public.active_storage_blobs USING btree (key);


--
-- Name: index_unique_active_storage_variant_records; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_active_storage_variant_records ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_unique_blueprint_activities; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_blueprint_activities ON public.blueprint_activities USING btree (blueprint_id, activity);


--
-- Name: index_unique_blueprint_activity_materials; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_blueprint_activity_materials ON public.blueprint_activity_materials USING btree (blueprint_id, activity, material_id);


--
-- Name: index_unique_blueprint_activity_products; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_blueprint_activity_products ON public.blueprint_activity_products USING btree (blueprint_id, activity, product_id);


--
-- Name: index_unique_blueprint_activity_skills; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_blueprint_activity_skills ON public.blueprint_activity_skills USING btree (blueprint_id, activity, skill_id);


--
-- Name: index_unique_default_identities; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_default_identities ON public.identities USING btree (user_id, "default");


--
-- Name: index_unique_esi_token_access_tokens; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_esi_token_access_tokens ON public.esi_tokens USING btree (access_token);


--
-- Name: index_unique_faction_races; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_faction_races ON public.faction_races USING btree (faction_id, race_id);


--
-- Name: index_unique_login_permits; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_login_permits ON public.login_permits USING btree (permittable_type, permittable_id);


--
-- Name: index_unique_market_locations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_locations ON public.market_locations USING btree (market_id, location_type, location_id);


--
-- Name: index_unique_market_order_snapshots; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_order_snapshots ON public.market_order_snapshots USING btree (source_id, esi_expires_at, created_at);


--
-- Name: index_unique_market_order_sources; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_order_sources ON public.market_order_sources USING btree (source_type, source_id);


--
-- Name: index_unique_market_orders; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_orders ON public.market_orders USING btree (source_id, order_id, created_at);


--
-- Name: index_unique_market_slugs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_slugs ON public.markets USING btree (slug);


--
-- Name: index_unique_market_sources; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_market_sources ON public.market_sources USING btree (market_id, source_id);


--
-- Name: index_unique_planet_schematic_inputs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_planet_schematic_inputs ON public.planet_schematic_inputs USING btree (schematic_id, type_id);


--
-- Name: index_unique_planet_schematic_pins; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_planet_schematic_pins ON public.planet_schematic_pins USING btree (schematic_id, type_id);


--
-- Name: index_unique_station_operation_services; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_station_operation_services ON public.station_operation_services USING btree (operation_id, service_id);


--
-- Name: index_unique_station_operation_station_types; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_station_operation_station_types ON public.station_operation_station_types USING btree (operation_id, race_id, type_id);


--
-- Name: index_unique_type_materials; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_type_materials ON public.type_materials USING btree (type_id, material_id);


--
-- Name: index_versions_on_item; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item ON public.versions USING btree (item_type, item_id);


--
-- Name: index_versions_on_item_type_and_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_event ON public.versions USING btree (item_type, event);


--
-- Name: index_versions_on_whodunnit_and_item_type_and_event; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_whodunnit_and_item_type_and_event ON public.versions USING btree (whodunnit, item_type, event);


--
-- Name: market_order_snapshots_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX market_order_snapshots_created_at_idx ON public.market_order_snapshots USING btree (created_at DESC);


--
-- Name: market_orders_created_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX market_orders_created_at_idx ON public.market_orders USING btree (created_at DESC);


--
-- Name: bloodlines logidze_on_bloodlines; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_bloodlines BEFORE INSERT OR UPDATE ON public.bloodlines FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: blueprint_activities logidze_on_blueprint_activities; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_blueprint_activities BEFORE INSERT OR UPDATE ON public.blueprint_activities FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: blueprint_activity_materials logidze_on_blueprint_activity_materials; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_blueprint_activity_materials BEFORE INSERT OR UPDATE ON public.blueprint_activity_materials FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: blueprint_activity_products logidze_on_blueprint_activity_products; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_blueprint_activity_products BEFORE INSERT OR UPDATE ON public.blueprint_activity_products FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: blueprint_activity_skills logidze_on_blueprint_activity_skills; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_blueprint_activity_skills BEFORE INSERT OR UPDATE ON public.blueprint_activity_skills FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: categories logidze_on_categories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_categories BEFORE INSERT OR UPDATE ON public.categories FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: celestials logidze_on_celestials; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_celestials BEFORE INSERT OR UPDATE ON public.celestials FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: constellations logidze_on_constellations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_constellations BEFORE INSERT OR UPDATE ON public.constellations FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: corporations logidze_on_corporations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_corporations BEFORE INSERT OR UPDATE ON public.corporations FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: dogma_attributes logidze_on_dogma_attributes; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_dogma_attributes BEFORE INSERT OR UPDATE ON public.dogma_attributes FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: dogma_categories logidze_on_dogma_categories; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_dogma_categories BEFORE INSERT OR UPDATE ON public.dogma_categories FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: dogma_effects logidze_on_dogma_effects; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_dogma_effects BEFORE INSERT OR UPDATE ON public.dogma_effects FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: faction_races logidze_on_faction_races; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_faction_races BEFORE INSERT OR UPDATE ON public.faction_races FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: factions logidze_on_factions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_factions BEFORE INSERT OR UPDATE ON public.factions FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: graphics logidze_on_graphics; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_graphics BEFORE INSERT OR UPDATE ON public.graphics FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: groups logidze_on_groups; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_groups BEFORE INSERT OR UPDATE ON public.groups FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: icons logidze_on_icons; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_icons BEFORE INSERT OR UPDATE ON public.icons FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: inventory_flags logidze_on_inventory_flags; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_inventory_flags BEFORE INSERT OR UPDATE ON public.inventory_flags FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: market_groups logidze_on_market_groups; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_market_groups BEFORE INSERT OR UPDATE ON public.market_groups FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: meta_groups logidze_on_meta_groups; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_meta_groups BEFORE INSERT OR UPDATE ON public.meta_groups FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: planet_schematic_inputs logidze_on_planet_schematic_inputs; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_planet_schematic_inputs BEFORE INSERT OR UPDATE ON public.planet_schematic_inputs FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: planet_schematic_pins logidze_on_planet_schematic_pins; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_planet_schematic_pins BEFORE INSERT OR UPDATE ON public.planet_schematic_pins FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: planet_schematics logidze_on_planet_schematics; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_planet_schematics BEFORE INSERT OR UPDATE ON public.planet_schematics FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: races logidze_on_races; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_races BEFORE INSERT OR UPDATE ON public.races FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: regions logidze_on_regions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_regions BEFORE INSERT OR UPDATE ON public.regions FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: solar_systems logidze_on_solar_systems; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_solar_systems BEFORE INSERT OR UPDATE ON public.solar_systems FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: static_data_versions logidze_on_static_data_versions; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_static_data_versions BEFORE INSERT OR UPDATE ON public.static_data_versions FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: station_operation_services logidze_on_station_operation_services; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_station_operation_services BEFORE INSERT OR UPDATE ON public.station_operation_services FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: station_operation_station_types logidze_on_station_operation_station_types; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_station_operation_station_types BEFORE INSERT OR UPDATE ON public.station_operation_station_types FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: station_operations logidze_on_station_operations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_station_operations BEFORE INSERT OR UPDATE ON public.station_operations FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: station_services logidze_on_station_services; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_station_services BEFORE INSERT OR UPDATE ON public.station_services FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: stations logidze_on_stations; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_stations BEFORE INSERT OR UPDATE ON public.stations FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: structures logidze_on_structures; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_structures BEFORE INSERT OR UPDATE ON public.structures FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: type_materials logidze_on_type_materials; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_type_materials BEFORE INSERT OR UPDATE ON public.type_materials FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: types logidze_on_types; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_types BEFORE INSERT OR UPDATE ON public.types FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: units logidze_on_units; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER logidze_on_units BEFORE INSERT OR UPDATE ON public.units FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE FUNCTION public.logidze_logger('null', 'updated_at');


--
-- Name: market_order_snapshots ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.market_order_snapshots FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: market_orders ts_insert_blocker; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER ts_insert_blocker BEFORE INSERT ON public.market_orders FOR EACH ROW EXECUTE FUNCTION _timescaledb_internal.insert_blocker();


--
-- Name: corporations fk_rails_0551373140; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporations
    ADD CONSTRAINT fk_rails_0551373140 FOREIGN KEY (alliance_id) REFERENCES public.alliances(id);


--
-- Name: market_order_snapshots fk_rails_11abb733ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_order_snapshots
    ADD CONSTRAINT fk_rails_11abb733ea FOREIGN KEY (source_id) REFERENCES public.market_order_sources(id);


--
-- Name: market_locations fk_rails_2c79e89ad9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_locations
    ADD CONSTRAINT fk_rails_2c79e89ad9 FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: market_sources fk_rails_49223ee5e8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_sources
    ADD CONSTRAINT fk_rails_49223ee5e8 FOREIGN KEY (source_id) REFERENCES public.market_order_sources(id);


--
-- Name: esi_tokens fk_rails_4e5ca194ce; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_tokens
    ADD CONSTRAINT fk_rails_4e5ca194ce FOREIGN KEY (identity_id) REFERENCES public.identities(id);


--
-- Name: identities fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: structures fk_rails_625050ce6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_625050ce6a FOREIGN KEY (solar_system_id) REFERENCES public.solar_systems(id);


--
-- Name: esi_tokens fk_rails_65dd1a1fd9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.esi_tokens
    ADD CONSTRAINT fk_rails_65dd1a1fd9 FOREIGN KEY (requester_id) REFERENCES public.identities(id);


--
-- Name: identities fk_rails_66c94802a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_rails_66c94802a5 FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: market_sources fk_rails_84aa70d00d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_sources
    ADD CONSTRAINT fk_rails_84aa70d00d FOREIGN KEY (market_id) REFERENCES public.markets(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: market_orders fk_rails_c96371e55e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.market_orders
    ADD CONSTRAINT fk_rails_c96371e55e FOREIGN KEY (source_id) REFERENCES public.market_order_sources(id);


--
-- Name: structures fk_rails_ce74d43aa1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_ce74d43aa1 FOREIGN KEY (type_id) REFERENCES public.types(id);


--
-- Name: structures fk_rails_e4a1bb1cde; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.structures
    ADD CONSTRAINT fk_rails_e4a1bb1cde FOREIGN KEY (corporation_id) REFERENCES public.corporations(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20220321174746'),
('20220523164403'),
('20220523164503'),
('20220523210147'),
('20220523211416'),
('20220524172419'),
('20220524180358'),
('20220524195739'),
('20220524195908'),
('20220524200058'),
('20220525014307'),
('20220525015515'),
('20220525020938'),
('20220525021716'),
('20220525030011'),
('20220525123955'),
('20220525124621'),
('20220525125404'),
('20220525135721'),
('20220525142514'),
('20220525142902'),
('20220525143716'),
('20220525151451'),
('20220525161306'),
('20220525163516'),
('20220525181655'),
('20220526135502'),
('20220526141538'),
('20220526154906'),
('20220526161623'),
('20220526165548'),
('20220526171131'),
('20220526190300'),
('20220526201528'),
('20220526204250'),
('20220528152440'),
('20220528152441'),
('20220528152902'),
('20220528153914'),
('20220528153926'),
('20220528153939'),
('20220528153953'),
('20220528154006'),
('20220528154118'),
('20220528154129'),
('20220528154151'),
('20220528154203'),
('20220528154328'),
('20220528154338'),
('20220528154401'),
('20220528154414'),
('20220528154423'),
('20220528154435'),
('20220528154451'),
('20220528154512'),
('20220528154522'),
('20220528154532'),
('20220528154542'),
('20220528154553'),
('20220528154607'),
('20220528154621'),
('20220528154632'),
('20220528154640'),
('20220528154700'),
('20220528154715'),
('20220528154727'),
('20220528154736'),
('20220528154749'),
('20220528154801'),
('20220528154811'),
('20220528155025'),
('20220528155421'),
('20220528200046'),
('20220529005304'),
('20220531005714'),
('20220531125520'),
('20220531134446'),
('20220531141017'),
('20220531143606'),
('20220531150127'),
('20220531163950'),
('20220601154559'),
('20220605174242'),
('20220606212008'),
('20220607010136'),
('20220609175309'),
('20220615201911'),
('20220616022650'),
('20220617005645'),
('20220617010810'),
('20220617134151'),
('20220617134849'),
('20220617142418'),
('20220617144652');


