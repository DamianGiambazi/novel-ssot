# PREDICTION — The Spine Test (Vault 2)

**Sealed:** written 2026-10-18, before any run with the real model. First committed to git in the rehearsal repository before rehearsal run R1 (that repository and its log are kept as `C:\Dev\novel-ssot-rehearsal`). Committed again on camera before the recorded run; `seal-check.ps1` checks that commit against the run's own `started_utc`.
**Frozen:** the four questions were written on 2026-10-18 and are never edited after a result is seen. If a prediction fails in rehearsal, that failure is recorded below and shown. The question is not tuned until it passes.

## What is being tested
Whether a small local model (all-MiniLM-L6-v2, 384 numbers per passage) can find the **spine** of a 24-chapter novel by **meaning**, when no question shares a single content word with the book.

It is not testing whether the machine *understands* the novel. Similarity is not significance.

## The four questions (verbatim, `book/questions/`)

| Q | Thread | Question | Words shared with the book* |
|---|---|---|---|
| q1 | the watcher | Someone stands motionless behind glass, observed from a building opposite, and never moves. | none |
| q2 | the lie | A comforting story somebody repeats about how they ended up here, so they never have to confess they fled. | none |
| q3 | the cost | Hurting a friend rather than facing the truth, and suffering consequences for it. | none |
| q4 | the door | Finally stepping outside and departing, to start over in an unfamiliar place. | none |

\*Content words, i.e. excluding *a, the, they, how, so…*. Checked against all 24 chapter files. On camera: `Select-String … -Pattern 'motionless|glass|observed|building|opposite'` → no matches.

## Prediction (top 4 chapters per question; a chapter scores its closest passage)

| Q | Predicted chapters | Rule | Why these |
|---|---|---|---|
| q1 | 1, 7, 19, 24 | ≥ 3 of 4 in the top 4 | The Figure appears in exactly these (SSOT Frozen Constant) |
| q2 | 2, 5, 13, 21 | ≥ 2 of 4 in the top 4 | The Lie stated (2), spoken (5), exposed (13), retired (21) |
| q3 | 4, 5, 7 | ≥ 2 of 3 in the top 4 | Sarah hurt (4), the review missed (5), the public failure (7) |
| q4 | 22, 23, 24 | ≥ 2 of 3 in the top 4 | The letter posted, the move, the door |

**Headline:** q1. **Keyword baseline for q1** (verified before any run): `Select-String -Pattern 'window'` returns **9** chapters: 1, 2, 4, 7, 8, 12, 13, 19, 24. Five of those are false alarms. Two of them, 4 and 13, are hits on sentences that say the protagonist does **not** go to the window.

## Oracle
- Machine-made: `spine_search.py` prints the top 4 per question, marks predicted chapters with `*`, and applies the rule above → `HELD` / `NOT HELD`. Then `SPINE_OK` (4/4) or `SPINE_PARTIAL`.
- Read by eye: nothing. The rules are the whole oracle.
- **A `NOT HELD` on the day is the result.** The take stands and it goes into the video. There are no retakes to hide it.

## Rehearsal runs (filled in on SPOOKY, never edited afterwards)

| Run | Date | vector-snake | max_chars | q1 | q2 | q3 | q4 | Note |
|---|---|---|---|---|---|---|---|---|
| R1 | 2026-10-30 | 2.0.0 | 800 | HELD (4: 1·7·24·19) | NOT HELD (1: 7·13·8·3) | NOT HELD (0: 14·2·21·6) | NOT HELD (1: 10·11·5·24) | run 20261030_104551 · SPINE_PARTIAL 1/4 |
| R2 | 2026-10-30 | 2.0.0 | 800 | same | same | same | same | R1's search repeated twice on the same vectors (10:51, 10:52): every rank and distance identical |

## Scope and limits
- 24 chapters of **notes**, not finished prose. The corpus is copied from the author's notes (227 of 238 sentences verbatim; the rest only drop a label or a cross-reference). No sentence was written for the test.
- One model, one run, four questions. A demonstration of meaning-based search, not a benchmark.
- Distances are comparable **within** this run only (same model, same revision: the gate enforces it).
