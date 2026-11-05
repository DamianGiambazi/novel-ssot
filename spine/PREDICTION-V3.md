# PREDICTION — Vault 3: The Door (Performance Edition)

**Sealed:** this file, `V3-PROMPT.txt`, `AMEND-PROMPT.txt` and `seal-check-v3.ps1` are committed and pushed to `novel-ssot` **before** the reader's first call. `.\spine\seal-check-v3.ps1` compares the commit time with the first line of the call log and must print `SEALED_BEFORE_RUN`.
**Unchanged from Vault 2:** the four questions (`book/questions/`, written 18 Oct), the predicted chapters and the pass rules (`spine/PREDICTION.md`). Only the method changes.

## The rehearsal (3 Nov 2026), and why this is a second take
The method was first run on 3 Nov, live, on this repository. It worked, after eight fixes found on the way (the snag ledger, V3-S02 to S09). That run is treated as the rehearsal:
- its record is kept, not deleted: the branch **`v3-rehearsal`** (the seal `585cee9` and the author's commit `a3fc6e3`) and the closed issue **#1**;
- `main` was then returned to the end of Vault 2 (`dc9e692`), so this take starts from the same place.

The people watching this take know the rehearsal's result, and so does this prediction. A prediction made after seeing a result is weaker, so this one adds a second, behavioural test the rehearsal suggested.

## The baseline: Vault 2, local only
Run `20261101_171405` · `GATE_PASS … chunks=29` · **`SPINE_PARTIAL 1/4`**. Every rank and distance was identical on 30 Oct and 1 Nov.

| Q | Thread | Vault 2 top 4 (closest passage per chapter) | Result |
|---|---|---|---|
| Q1 | the watcher | ch-01 0.5717 · ch-07 0.5758 · ch-24 0.5851 · ch-19 0.5940 | HELD (4 of 4) |
| Q2 | the lie | 7 · 13 · 8 · 3 | NOT HELD |
| Q3 | the cost | 14 · 2 · 21 · 6 | NOT HELD |
| Q4 | the door | 10 · 11 · 5 · 24 | NOT HELD |

## The rehearsal run (recorded; never edited)
| Run | Date | Model (as Claude Desktop showed it) | Q1 | Q2 | Q3 | Q4 | Held | Tool calls | chars out | Strategy |
|---|---|---|---|---|---|---|---|---|---|---|
| R1 | 2026-11-03 | Opus 5.5 · Medium | 19, 7, 1, 24 HELD | 5, 21, 2, 6 HELD | 5, 4, 9, 20 HELD | 24, 23, 22, 10 HELD | **4/4** | 24 (all `read_chapter`) | 10,927 | read all 24 chapters; **no search** |

## What changes
| | Vault 2 | Vault 3 |
|---|---|---|
| Who reads the questions | nobody: they are turned into 384 numbers | a frontier model in Claude Desktop |
| What the laptop does | searches by meaning (MiniLM + LanceDB) | serves the book through four tools: meaning search, keyword search, chapter text, one proposal |
| Who chooses the chapters | the nearest numbers | the model, using whichever tools it wants |
| What leaves the laptop | nothing | text only (audited by `calls.sql`) |

## The predictions
**P1 · The spine.** All four threads are found: **4 of 4 held** under the Vault 2 rules.

| Q | Thread | Predicted chapters (unchanged) | Rule (unchanged) |
|---|---|---|---|
| Q1 | the watcher | 1, 7, 19, 24 | ≥ 3 of 4 in the model's top 4 |
| Q2 | the lie | 2, 5, 13, 21 | ≥ 2 of 4 |
| Q3 | the cost | 4, 5, 7 | ≥ 2 of 3 |
| Q4 | the door | 22, 23, 24 | ≥ 2 of 3 |

**P2 · The strategy.** The book is about 11,000 characters, small enough to read whole. The reader **reads the whole book**: at least 20 of the 24 chapters through `read_chapter`. Machine check: `calls.sql` prints `READ_WHOLE_BOOK` (or `SELECTIVE_READER`).

**P3 · The door.**
1. Before sign-in, the tool is blocked: the smoke test prints `DOOR shut`, and the first real call returns *Authorization required*.
2. After the author's GitHub sign-in (through Arcade), an issue appears on `novel-ssot`. (Issue numbers are never reused, so it will be #2 or later.)
3. `SSOT.md` is unchanged until the author commits a change that closes the issue.

## Fair-test conditions
- The model sees the novel **only** through `novel_door`: four tools and 24 chapter files. It cannot see `SSOT.md`, the prediction files or the Machine Evidence table.
- Claude Desktop: a **chat** (not a Code or Cowork session), **no project**, web search **off**, **Claude in Chrome off**, no connector but novel_door, memory **off**, reference past chats **off**, Tool access **"Tools already loaded"**, a new chat opened after novel_door shows **Running**. The repository is public and holds the answers; the model must not be able to read it.
- The prompt is `spine/V3-PROMPT.txt`, pasted verbatim. Scoring is mechanical: `score.py` on the model's last four lines. Four different chapters per question.
- The model is not deterministic. **The one recorded run is the result.** It is not re-run for a better score.

## If something breaks on camera
It stays in the take and in this repository's history, is fixed one change at a time, and is named. If the reader's run is voided (it used the web, or a tool was refused), the void and its reason are stated aloud, and the next run in a new chat is the result.

## Scope and limits
Same four questions, one model, one take. This shows a division of labour (local library, remote reading, human decision), not a benchmark. A held thread means the model's chapters match the author's, not that the model understands the book.
