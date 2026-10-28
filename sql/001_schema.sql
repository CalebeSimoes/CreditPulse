-- Base de proveniência/staging. O modelo canônico depende da inspeção da fonte.
-- Não inventar colunas de negócio antes de validar target e granularidade.
CREATE SCHEMA IF NOT EXISTS ops;
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS canonical;
CREATE SCHEMA IF NOT EXISTS mart;
CREATE SCHEMA IF NOT EXISTS ml;

CREATE TABLE IF NOT EXISTS ops.source_registry (
    source_name TEXT PRIMARY KEY,
    source_version TEXT NOT NULL,
    source_url TEXT NOT NULL,
    terms_reference TEXT,
    is_synthetic BOOLEAN NOT NULL DEFAULT FALSE,
    registered_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ops.ingestion_batch (
    batch_id UUID PRIMARY KEY,
    source_name TEXT NOT NULL REFERENCES ops.source_registry(source_name),
    source_version TEXT NOT NULL,
    dataset_version TEXT NOT NULL,
    file_name TEXT NOT NULL,
    content_sha256 TEXT NOT NULL,
    row_count BIGINT CHECK (row_count >= 0),
    status TEXT NOT NULL CHECK (status IN ('started','validated','quarantined','failed')),
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- JSONB preserva o payload da origem; tabelas tipadas source-specific serão
-- criadas após a ficha da fonte e perfilamento. Nunca inserir PII não autorizada.
CREATE TABLE IF NOT EXISTS raw.source_record (
    batch_id UUID NOT NULL REFERENCES ops.ingestion_batch(batch_id),
    source_record_key TEXT NOT NULL,
    payload JSONB NOT NULL,
    loaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (batch_id, source_record_key)
);

CREATE TABLE IF NOT EXISTS ops.quarantine_record (
    batch_id UUID NOT NULL REFERENCES ops.ingestion_batch(batch_id),
    source_record_key TEXT NOT NULL,
    reason_code TEXT NOT NULL,
    details JSONB NOT NULL DEFAULT '{}'::jsonb,
    quarantined_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    PRIMARY KEY (batch_id, source_record_key, reason_code)
);
