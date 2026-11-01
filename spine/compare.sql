-- compare.sql — Vault 2 close: is the rebuild in the fresh clone the same as the original?
-- Run from the CLONE's root (C:\Dev\novel-ssot-clone):   duckdb -bail -f spine\compare.sql
--   receipts\  = the original run's receipts, as committed to GitHub (no vectors: those are .gitignored)
--   rebuild\   = the new vector-snake run made in this clone
--   orig_csv   = the original vectors, still on this machine in the first working copy

.mode box
SET VARIABLE orig_csv = 'C:/Dev/novel-ssot/receipts/*_vectors.csv';

-- 1. The cuts. Every passage's text fingerprint, original receipt vs rebuild receipt.
WITH o AS (SELECT source.file AS f, unnest(chunks) AS c
           FROM read_json_auto('receipts/*_manifest.json', union_by_name = true, filename = true)
           WHERE filename NOT LIKE '%run_manifest.json'),
     r AS (SELECT source.file AS f, unnest(chunks) AS c
           FROM read_json_auto('rebuild/*_manifest.json', union_by_name = true, filename = true)
           WHERE filename NOT LIKE '%run_manifest.json')
SELECT CASE WHEN count(*) > 0 AND count(*) = count(*) FILTER (WHERE o.c.text_sha256 = r.c.text_sha256)
            THEN 'CUTS_IDENTICAL' ELSE error('CUTS_DIFFER') END AS cuts,
       count(*)                                              AS passages,
       count(*) FILTER (WHERE o.c.text_sha256 = r.c.text_sha256) AS identical_text,
       count(*) FILTER (WHERE o.c.base_start = r.c.base_start
                          AND o.c.base_end = r.c.base_end)   AS identical_cuts
FROM o JOIN r ON o.f = r.f AND o.c.index = r.c.index;

-- 2. The numbers. Each passage's 384 numbers, original vs rebuild: how far apart can they be?
SELECT CASE WHEN min(array_cosine_similarity(CAST(a.vector_json AS FLOAT[384]), CAST(b.vector_json AS FLOAT[384]))) >= 0.9999
            THEN 'VECTORS_MATCH' ELSE error('VECTORS_DIFFER') END AS numbers,
       count(*)                                                    AS vectors,
       round(min(array_cosine_similarity(
             CAST(a.vector_json AS FLOAT[384]), CAST(b.vector_json AS FLOAT[384]))), 6) AS min_cosine
FROM read_csv_auto(getvariable('orig_csv')) a
JOIN read_csv_auto('rebuild/*_vectors.csv') b USING (id);

SELECT 'REBUILD_MATCHES_RECEIPT' AS verdict;
