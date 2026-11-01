"""spine_search.py — Vault 2: ask the novel four questions by meaning, compare with the prediction.

Run from the repo root (C:\\Dev\\novel-ssot) with the smoke-lab venv from Vault 1:
    C:\\Dev\\smoke-lab\\.venv\\Scripts\\python.exe spine\\spine_search.py

Inputs : spine\\corpus.parquet, spine\\questions.parquet  (written by `duckdb -bail -f spine\\gate.sql`
         only if the gate passed)
Needs  : lancedb (+ pyarrow) — already in the smoke-lab venv. No model is loaded here: the questions
         were turned into numbers by the SAME vector-snake run as the chapters.

Method : for each question, LanceDB ranks every passage by cosine distance; a chapter's score is its
         closest passage. The top 4 chapters are compared with the chapters predicted in
         spine\\PREDICTION.md, which was committed to git BEFORE the run.
"""
import os, shutil, sys, tempfile

import pyarrow as pa
import pyarrow.parquet as pq
import lancedb

sys.stdout.reconfigure(errors="replace")

DIM, TOP = 384, 4
# ---- pre-registered (must match spine\PREDICTION.md, committed before the run) ---------------
EXPECTED = {
    "q1": ({1, 7, 19, 24}, 3),   # the watcher in the window      — at least 3 of 4 in the top 4
    "q2": ({2, 5, 13, 21}, 2),   # the lie they tell themselves   — at least 2 of 4 in the top 4
    "q3": ({4, 5, 7},      2),   # the cost of pretending         — at least 2 of 3 in the top 4
    "q4": ({22, 23, 24},   2),   # the door                       — at least 2 of 3 in the top 4
}
LABEL = {"q1": "the watcher", "q2": "the lie", "q3": "the cost", "q4": "the door"}
# ---------------------------------------------------------------------------------------------

def fixed(table: pa.Table) -> pa.Table:
    """Parquet stores DuckDB's FLOAT[384] as a variable list; LanceDB wants a fixed-size vector."""
    flat = table.column("vector").combine_chunks().flatten()
    vec = pa.FixedSizeListArray.from_arrays(flat, DIM)
    return table.set_column(table.schema.get_field_index("vector"), "vector", vec)

corpus = fixed(pq.read_table("spine/corpus.parquet"))
questions = pq.read_table("spine/questions.parquet").to_pylist()

db_dir = os.path.join(tempfile.gettempdir(), "lancedb_spine")
shutil.rmtree(db_dir, ignore_errors=True)
tbl = lancedb.connect(db_dir).create_table("book", data=corpus, mode="overwrite")

chapters = len(set(corpus.column("chapter").to_pylist()))
print(f"SPINE      {chapters} chapters · {corpus.num_rows} passages · cosine distance · "
      f"a chapter scores its closest passage")
held = 0
for q in questions:
    qid = q["qid"]
    hits = tbl.search(q["vector"]).distance_type("cosine").limit(corpus.num_rows).to_list()
    best = {}
    for h in hits:                                   # hits arrive nearest first
        best.setdefault(h["chapter"], h)
    ranked = list(best.values())[:TOP]
    expected, need = EXPECTED[qid]
    found = [h["chapter"] for h in ranked if h["chapter"] in expected]
    ok = len(found) >= need
    held += ok
    print(f"\n{qid.upper()} ({LABEL[qid]})  {q['text']}")
    for rank, h in enumerate(ranked, 1):
        mark = "*" if h["chapter"] in expected else " "
        print(f"   {rank}  ch-{h['chapter']:02d}{mark} {h['_distance']:.4f}  {h['text'][:62]!r}")
    print(f"   expected {sorted(expected)} · {len(found)} of them in the top {TOP} · "
          f"rule ≥{need} → {'HELD' if ok else 'NOT HELD'}")

shutil.rmtree(db_dir, ignore_errors=True)
print(f"\n{'SPINE_OK' if held == len(questions) else 'SPINE_PARTIAL'}  "
      f"{held}/{len(questions)} predictions held   (* = predicted chapter)")
