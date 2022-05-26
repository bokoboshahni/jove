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
-- Name: universe; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.universe AS ENUM (
    'abyssal',
    'eve',
    'void',
    'wormhole'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

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
    updated_at timestamp(6) without time zone NOT NULL
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
    "time" interval NOT NULL
);


--
-- Name: blueprint_activity_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_materials (
    blueprint_id bigint NOT NULL,
    material_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    quantity integer NOT NULL
);


--
-- Name: blueprint_activity_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_products (
    blueprint_id bigint NOT NULL,
    product_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    quantity integer NOT NULL,
    probability numeric
);


--
-- Name: blueprint_activity_skills; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blueprint_activity_skills (
    blueprint_id bigint NOT NULL,
    skill_id bigint NOT NULL,
    activity public.blueprint_activity NOT NULL,
    level integer NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    celestial_type public.celestial_type NOT NULL,
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
    updated_at timestamp(6) without time zone NOT NULL
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
    wormhole_class_id bigint
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
    size text
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: dogma_effect_modifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dogma_effect_modifiers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    effect_id bigint NOT NULL,
    group_id bigint,
    modified_attribute_id bigint,
    modified_effect_id bigint,
    modifying_attribute_id bigint,
    operation_id bigint,
    skill_id bigint,
    domain text NOT NULL,
    function text NOT NULL
);


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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: faction_races; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faction_races (
    faction_id bigint NOT NULL,
    race_id bigint NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    permittable_type character varying,
    permittable_id bigint,
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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: meta_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.meta_groups (
    id bigint NOT NULL,
    icon_id bigint,
    description text,
    icon_suffix text,
    name text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: planet_schematic_inputs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.planet_schematic_inputs (
    schematic_id bigint NOT NULL,
    type_id bigint NOT NULL,
    quantity integer NOT NULL
);


--
-- Name: planet_schematic_pins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.planet_schematic_pins (
    schematic_id bigint NOT NULL,
    type_id bigint NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: static_data_imports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.static_data_imports (
    id bigint NOT NULL,
    version_id bigint NOT NULL,
    state text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: static_data_imports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.static_data_imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: static_data_imports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.static_data_imports_id_seq OWNED BY public.static_data_imports.id;


--
-- Name: static_data_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.static_data_versions (
    id bigint NOT NULL,
    checksum text NOT NULL,
    state text NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    service_id bigint NOT NULL
);


--
-- Name: station_operation_station_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.station_operation_station_types (
    operation_id bigint NOT NULL,
    race_id bigint NOT NULL,
    type_id bigint NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: type_materials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.type_materials (
    type_id bigint NOT NULL,
    material_id bigint NOT NULL,
    quantity integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    traits jsonb
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
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: meta_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_groups ALTER COLUMN id SET DEFAULT nextval('public.meta_groups_id_seq'::regclass);


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
-- Name: static_data_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_imports ALTER COLUMN id SET DEFAULT nextval('public.static_data_imports_id_seq'::regclass);


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
-- Name: dogma_effect_modifiers dogma_effect_modifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_effect_modifiers
    ADD CONSTRAINT dogma_effect_modifiers_pkey PRIMARY KEY (id);


--
-- Name: dogma_effects dogma_effects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dogma_effects
    ADD CONSTRAINT dogma_effects_pkey PRIMARY KEY (id);


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
-- Name: meta_groups meta_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.meta_groups
    ADD CONSTRAINT meta_groups_pkey PRIMARY KEY (id);


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
-- Name: static_data_imports static_data_imports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_imports
    ADD CONSTRAINT static_data_imports_pkey PRIMARY KEY (id);


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
-- Name: index_blueprint_activities_on_blueprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activities_on_blueprint_id ON public.blueprint_activities USING btree (blueprint_id);


--
-- Name: index_blueprint_activity_materials_on_blueprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_materials_on_blueprint_id ON public.blueprint_activity_materials USING btree (blueprint_id);


--
-- Name: index_blueprint_activity_materials_on_material_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_materials_on_material_id ON public.blueprint_activity_materials USING btree (material_id);


--
-- Name: index_blueprint_activity_products_on_blueprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_products_on_blueprint_id ON public.blueprint_activity_products USING btree (blueprint_id);


--
-- Name: index_blueprint_activity_products_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_products_on_product_id ON public.blueprint_activity_products USING btree (product_id);


--
-- Name: index_blueprint_activity_skills_on_blueprint_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blueprint_activity_skills_on_blueprint_id ON public.blueprint_activity_skills USING btree (blueprint_id);


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
-- Name: index_dogma_effect_modifiers_on_effect_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_effect_id ON public.dogma_effect_modifiers USING btree (effect_id);


--
-- Name: index_dogma_effect_modifiers_on_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_group_id ON public.dogma_effect_modifiers USING btree (group_id);


--
-- Name: index_dogma_effect_modifiers_on_modified_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_modified_attribute_id ON public.dogma_effect_modifiers USING btree (modified_attribute_id);


--
-- Name: index_dogma_effect_modifiers_on_modified_effect_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_modified_effect_id ON public.dogma_effect_modifiers USING btree (modified_effect_id);


--
-- Name: index_dogma_effect_modifiers_on_modifying_attribute_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_modifying_attribute_id ON public.dogma_effect_modifiers USING btree (modifying_attribute_id);


--
-- Name: index_dogma_effect_modifiers_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_operation_id ON public.dogma_effect_modifiers USING btree (operation_id);


--
-- Name: index_dogma_effect_modifiers_on_skill_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_dogma_effect_modifiers_on_skill_id ON public.dogma_effect_modifiers USING btree (skill_id);


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
-- Name: index_faction_races_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_faction_races_on_faction_id ON public.faction_races USING btree (faction_id);


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
-- Name: index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_identities_on_user_id ON public.identities USING btree (user_id);


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
-- Name: index_login_permits_on_permittable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_login_permits_on_permittable ON public.login_permits USING btree (permittable_type, permittable_id);


--
-- Name: index_market_groups_on_ancestry; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_groups_on_ancestry ON public.market_groups USING btree (ancestry);


--
-- Name: index_market_groups_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_market_groups_on_icon_id ON public.market_groups USING btree (icon_id);


--
-- Name: index_meta_groups_on_icon_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_meta_groups_on_icon_id ON public.meta_groups USING btree (icon_id);


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
-- Name: index_static_data_imports_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_static_data_imports_on_version_id ON public.static_data_imports USING btree (version_id);


--
-- Name: index_station_operation_services_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_services_on_operation_id ON public.station_operation_services USING btree (operation_id);


--
-- Name: index_station_operation_services_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_services_on_service_id ON public.station_operation_services USING btree (service_id);


--
-- Name: index_station_operation_station_types_on_operation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_station_operation_station_types_on_operation_id ON public.station_operation_station_types USING btree (operation_id);


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
-- Name: index_unique_faction_races; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_faction_races ON public.faction_races USING btree (faction_id, race_id);


--
-- Name: index_unique_login_permits; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_login_permits ON public.login_permits USING btree (permittable_type, permittable_id);


--
-- Name: index_unique_planet_schematic_inputs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_planet_schematic_inputs ON public.planet_schematic_inputs USING btree (schematic_id, type_id);


--
-- Name: index_unique_planet_schematic_pins; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_planet_schematic_pins ON public.planet_schematic_pins USING btree (schematic_id, type_id);


--
-- Name: index_unique_static_data_versions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_static_data_versions ON public.static_data_versions USING btree (checksum);


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
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: static_data_imports fk_rails_c097cc8b57; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_imports
    ADD CONSTRAINT fk_rails_c097cc8b57 FOREIGN KEY (version_id) REFERENCES public.static_data_versions(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


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
('20220526201528');


