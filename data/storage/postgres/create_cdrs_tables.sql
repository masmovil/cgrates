--
-- Table structure for table `cdrs`
--

CREATE TABLE IF NOT EXISTS cdrs (
  id SERIAL PRIMARY KEY,
  cgrid VARCHAR(40) NOT NULL,
  run_id VARCHAR(64) NOT NULL,
  origin_host VARCHAR(64) NOT NULL,
  source VARCHAR(64) NOT NULL,
  origin_id VARCHAR(128) NOT NULL,
  tor VARCHAR(16) NOT NULL,
  request_type VARCHAR(24) NOT NULL,
  tenant VARCHAR(64) NOT NULL,
  category VARCHAR(64) NOT NULL,
  account VARCHAR(128) NOT NULL,
  subject VARCHAR(128) NOT NULL,
  destination VARCHAR(128) NOT NULL,
  setup_time TIMESTAMP WITH TIME ZONE NOT NULL,
  answer_time TIMESTAMP WITH TIME ZONE NOT NULL,
  usage BIGINT NOT NULL,
  extra_fields jsonb NOT NULL,
  cost_source VARCHAR(64) NOT NULL,
  cost NUMERIC(23,7) DEFAULT NULL,
  cost_details jsonb,
  extra_info text,
  created_at TIMESTAMP WITH TIME ZONE,
  updated_at TIMESTAMP WITH TIME ZONE NULL,
  deleted_at TIMESTAMP WITH TIME ZONE NULL,
  UNIQUE (cgrid, run_id)
);

CREATE INDEX IF NOT EXISTS deleted_at_cp_idx ON cdrs (deleted_at);

CREATE TABLE IF NOT EXISTS session_costs (
  id SERIAL PRIMARY KEY,
  cgrid VARCHAR(40) NOT NULL,
  run_id  VARCHAR(64) NOT NULL,
  origin_host VARCHAR(64) NOT NULL,
  origin_id VARCHAR(128) NOT NULL,
  cost_source VARCHAR(64) NOT NULL,
  usage BIGINT NOT NULL,
  cost_details jsonb,
  created_at TIMESTAMP WITH TIME ZONE,
  deleted_at TIMESTAMP WITH TIME ZONE NULL,
  UNIQUE (cgrid, run_id)
);

CREATE INDEX IF NOT EXISTS cgrid_sessionscost_idx ON session_costs (cgrid, run_id);
CREATE INDEX IF NOT EXISTS origin_sessionscost_idx ON session_costs (origin_host, origin_id);
CREATE INDEX IF NOT EXISTS run_origin_sessionscost_idx ON session_costs (run_id, origin_id);
CREATE INDEX IF NOT EXISTS deleted_at_sessionscost_idx ON session_costs (deleted_at);
