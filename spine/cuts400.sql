-- cuts400.sql — Vault 2 §4: the same view as cuts.sql at --max-chars 400 (reads preview400\, nothing is embedded).
-- Run from the repo root:   duckdb -bail -f spine\cuts400.sql
-- Same as cuts.sql, reading preview400\ (--max-chars 400).

.mode box
.maxwidth 120
SET VARIABLE dir = 'preview400';

-- 1. The whole book at this budget: how many passages each file became.
SELECT any_value(chunking.max_chars) AS max_chars, count(*) AS files,
       sum(chunking.chunk_count) AS passages,
       count(*) FILTER (WHERE chunking.chunk_count > 1) AS files_cut,
       sum(len(list_filter(audit.checks, lambda c: NOT c.passed))) AS failed_checks
FROM read_json_auto(getvariable('dir') || '/*_preview.json');

-- 2. Every file that had to be cut, and where.
SELECT source_file AS file, c.index AS passage, c.base_start AS starts, c.base_end AS ends,
       coalesce(c.prefix_end - c.prefix_start, 0) AS run_up,
       replace(left(c.text, 58), chr(10), ' ') || '…' AS begins_with
FROM (SELECT source_file, unnest(chunks) AS c
      FROM read_json_auto(getvariable('dir') || '/*_preview.json')
      WHERE chunking.chunk_count > 1)
ORDER BY file, passage;
