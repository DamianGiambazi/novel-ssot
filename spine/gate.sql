-- gate.sql — Vault 2 gate: DuckDB audits ONE vector-snake run over book\ (24 chapters + 4 questions),
-- then exports clean evidence. Run from the repo root:   duckdb -bail -f spine\gate.sql
-- Input : receipts\  *_vectors.csv (one per file), *_manifest.json (one per file), *_run_manifest.json (one)
-- Output: spine\corpus.parquet, spine\questions.parquet — written only if every gate below passes.

.mode box
.maxwidth 120

-- 1. vector-snake's own verdict on its run.
SELECT run_id, summary.inputs AS inputs, summary.passed AS passed,
       summary.warned AS warned, summary.failed AS failed, config.max_chars AS max_chars, config.overlap AS overlap
FROM read_json_auto('receipts/*_run_manifest.json');

-- 2. What did it hand us? One row per chapter or question.
SELECT regexp_extract(source_file, '(ch-\d\d|q\d)', 1) AS file, count(*) AS chunks,
       any_value(embedding_model) AS model, any_value(vector_dim) AS dim
FROM read_csv_auto('receipts/*_vectors.csv')
GROUP BY ALL ORDER BY file;

-- 3. The gate: one run, nothing failed or warned (a warning here means a truncated passage), one model, one size, no duplicate ids, every vector really
--    holds vector_dim numbers, all 24 chapters present, exactly four questions.
SELECT CASE
         WHEN m.runs = 1 AND m.failed = 0 AND m.warned = 0
          AND c.models = 1 AND c.dims = 1 AND c.dup_ids = 0 AND c.bad_vectors = 0
          AND c.chapters = 24 AND c.question_rows = 4
         THEN 'GATE_PASS  runs=1  chapters=24  chunks=' || (c.rows - c.question_rows)
              || '  questions=4  model=' || c.model || '  dim=' || c.dim
         ELSE error('GATE_FAIL  runs=' || m.runs || ' failed=' || m.failed || ' warned=' || m.warned || ' models=' || c.models
                    || ' dims=' || c.dims || ' dup_ids=' || c.dup_ids || ' bad_vectors=' || c.bad_vectors
                    || ' chapters=' || c.chapters || ' question_rows=' || c.question_rows)
       END AS verdict
FROM (SELECT count(*) AS runs, sum(summary.failed) AS failed, sum(summary.warned) AS warned
      FROM read_json_auto('receipts/*_run_manifest.json')) m,
     (SELECT count(*)                         AS rows,
             count(DISTINCT embedding_model)  AS models,
             count(DISTINCT vector_dim)       AS dims,
             any_value(embedding_model)       AS model,
             any_value(vector_dim)            AS dim,
             count(*) - count(DISTINCT id)    AS dup_ids,
             count(*) FILTER (WHERE len(CAST(vector_json AS FLOAT[])) <> vector_dim) AS bad_vectors,
             count(DISTINCT regexp_extract(source_file, 'ch-(\d\d)\.md$', 1))
               FILTER (WHERE regexp_matches(source_file, 'ch-\d\d\.md$'))           AS chapters,
             count(*) FILTER (WHERE regexp_matches(source_file, 'q\d\.txt$'))       AS question_rows
      FROM read_csv_auto('receipts/*_vectors.csv')) c;

-- 4. Export: readable text + typed vectors. Chapter number becomes a column.
COPY (
  SELECT id, CAST(regexp_extract(source_file, 'ch-(\d\d)\.md$', 1) AS INTEGER) AS chapter,
         chunk_index, text, CAST(vector_json AS FLOAT[384]) AS vector
  FROM read_csv_auto('receipts/*_vectors.csv')
  WHERE regexp_matches(source_file, 'ch-\d\d\.md$')
  ORDER BY chapter, chunk_index
) TO 'spine/corpus.parquet' (FORMAT parquet);

COPY (
  SELECT regexp_extract(source_file, '(q\d)\.txt$', 1) AS qid, text, CAST(vector_json AS FLOAT[384]) AS vector
  FROM read_csv_auto('receipts/*_vectors.csv')
  WHERE regexp_matches(source_file, 'q\d\.txt$')
  ORDER BY qid
) TO 'spine/questions.parquet' (FORMAT parquet);

SELECT 'EXPORT_OK' AS status;
