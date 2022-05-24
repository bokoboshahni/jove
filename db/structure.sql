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
    updated_at timestamp(6) without time zone NOT NULL
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
    ceo_id bigint NOT NULL,
    creator_id bigint NOT NULL,
    faction_id bigint,
    home_station_id bigint,
    description text,
    esi_etag text NOT NULL,
    esi_expires_at timestamp without time zone NOT NULL,
    esi_last_modified_at timestamp without time zone NOT NULL,
    founded_on date,
    member_count integer NOT NULL,
    name text NOT NULL,
    share_count integer,
    tax_rate numeric NOT NULL,
    ticker text NOT NULL,
    url text,
    war_eligible boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: static_data_imports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_imports ALTER COLUMN id SET DEFAULT nextval('public.static_data_imports_id_seq'::regclass);


--
-- Name: static_data_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.static_data_versions ALTER COLUMN id SET DEFAULT nextval('public.static_data_versions_id_seq'::regclass);


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
-- Name: index_constellations_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_constellations_on_region_id ON public.constellations USING btree (region_id);


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
-- Name: index_corporations_on_faction_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_faction_id ON public.corporations USING btree (faction_id);


--
-- Name: index_corporations_on_home_station_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporations_on_home_station_id ON public.corporations USING btree (home_station_id);


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
-- Name: index_static_data_imports_on_version_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_static_data_imports_on_version_id ON public.static_data_imports USING btree (version_id);


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
-- Name: index_unique_default_identities; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_default_identities ON public.identities USING btree (user_id, "default");


--
-- Name: index_unique_login_permits; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_login_permits ON public.login_permits USING btree (permittable_type, permittable_id);


--
-- Name: index_unique_static_data_versions; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_unique_static_data_versions ON public.static_data_versions USING btree (checksum);


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
('20220524172419');


