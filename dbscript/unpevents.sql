--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.10
-- Dumped by pg_dump version 14.4

--
-- Name: unpevents; Type: SCHEMA; Schema: -; Owner: unpevents
--

CREATE SCHEMA unpevents;


ALTER SCHEMA unpevents OWNER TO unpevents;

--
-- Name: events; Type: TABLE; Schema: unpevents; Owner: unpevents
--

CREATE TABLE unpevents.events (
    id bigint NOT NULL,
    uuid character varying(36) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    description text,
    payload text,
    source character varying(30) NOT NULL,
    type character varying(255),
    msg_uuid character varying(255),
    bulk_id character varying(255),
    user_id character varying(255),
    tag character varying(255),
    title character varying(255),
    correlation_id character varying(255),
    me_payload text,
    error text
);


ALTER TABLE unpevents.events OWNER TO unpevents;

--
-- Name: events_id_seq; Type: SEQUENCE; Schema: unpevents; Owner: unpevents
--

CREATE SEQUENCE unpevents.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE unpevents.events_id_seq OWNER TO unpevents;

--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: unpevents; Owner: unpevents
--

ALTER SEQUENCE unpevents.events_id_seq OWNED BY unpevents.events.id;


--
-- Name: messages_status; Type: TABLE; Schema: unpevents; Owner: unpevents
--

CREATE TABLE unpevents.messages_status (
    message_id character varying(255) NOT NULL,
    bulk_id character varying(255),
    email_result boolean,
    push_result boolean,
    sms_result boolean,
    io_result boolean,
    mex_result boolean,
    send_date timestamp with time zone,
    note text
);


ALTER TABLE unpevents.messages_status OWNER TO unpevents;

--
-- Name: stats; Type: TABLE; Schema: unpevents; Owner: unpevents
--

CREATE TABLE unpevents.stats (
    sender character varying(255) NOT NULL,
    date character(8) NOT NULL,
    source character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    counter numeric DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE unpevents.stats OWNER TO unpevents;

--
-- Name: events id; Type: DEFAULT; Schema: unpevents; Owner: unpevents
--

ALTER TABLE ONLY unpevents.events ALTER COLUMN id SET DEFAULT nextval('unpevents.events_id_seq'::regclass);


--
-- Name: events idx_10515534_primary; Type: CONSTRAINT; Schema: unpevents; Owner: unpevents
--

ALTER TABLE ONLY unpevents.events
    ADD CONSTRAINT idx_10515534_primary PRIMARY KEY (id);


--
-- Name: stats stats_pk; Type: CONSTRAINT; Schema: unpevents; Owner: unpevents
--

ALTER TABLE ONLY unpevents.stats
    ADD CONSTRAINT stats_pk PRIMARY KEY (sender, date, source, type, tenant);


--
-- Name: events_created_at_idx; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE INDEX events_created_at_idx ON unpevents.events USING btree (created_at);


--
-- Name: idx_10515534_created_at_type_index; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE INDEX idx_10515534_created_at_type_index ON unpevents.events USING btree (created_at, type);


--
-- Name: idx_10515534_msg_uuid; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE INDEX idx_10515534_msg_uuid ON unpevents.events USING btree (msg_uuid);


--
-- Name: idx_10515534_payload_ft; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE INDEX idx_10515534_payload_ft ON unpevents.events USING gin (to_tsvector('simple'::regconfig, payload));


--
-- Name: idx_10515959_message_id; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE UNIQUE INDEX idx_10515959_message_id ON unpevents.messages_status USING btree (message_id);


--
-- Name: messages_status_bulk_id_idx; Type: INDEX; Schema: unpevents; Owner: unpevents
--

CREATE INDEX messages_status_bulk_id_idx ON unpevents.messages_status USING btree (bulk_id);


--
-- PostgreSQL database dump complete
--

