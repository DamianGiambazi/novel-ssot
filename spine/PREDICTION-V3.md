# PREDICTION — Vault 3: The Door (Live Edition)

**Sealed:** this file, `V3-PROMPT.txt`, `AMEND-PROMPT.txt` and `seal-check-v3.ps1` are committed and pushed to `novel-ssot` **before** the reader's first call. `.\spine\seal-check-v3.ps1` compares the commit time with the first line of the call log and must print `SEALED_BEFORE_RUN`.
**Unchanged from Vault 2:** the four questions (`book/questions/`, written 18 Oct), the predicted chapters and the pass rules (`spine/PREDICTION.md`). Only the method changes.

## First contact
This prediction is sealed **before the tools exist on this machine**. At the moment of this commit:
- the door's virtual environment (`C:\Dev\novel-door\.venv`) has not been built;
- the Arcade command-line tool is not installed, and no Arcade sign-in exists;
- the GitHub App `novel-door` and its Arcade key do not exist;
- Claude Desktop has never been connected to the door.

**There were no rehearsal runs.** Nobody, the author included, has seen this reader answer these questions through this door. The method was scouted on paper and tested in a sandbox with a stand-in embedder (ranks meaningless there); this is the first time it runs on this laptop, and it is recorded in one take.

## The baseline: Vault 2, local only
Run `20261101_171405` · `GATE_PASS … chunks=29` · **`SPINE_PARTIAL 1/4`**. Every rank and distance was identical to the 30 Oct rehearsal.

| Q | Thread | Vault 2 top 4 (closest passage per chapter) | Result |
|---|---|---|---|
| Q1 | the watcher | ch-01 0.5717 · ch-07 0.5758 · ch-24 0.5851 · ch-19 0.5940 | HELD (4 of 4) |
| Q2 | the lie | 7 · 13 · 8 · 3 | NOT HELD |
| Q3 | the cost | 14 · 2 · 21 · 6 | NOT HELD |
| Q4 | the door | 10 · 11 · 5 · 24 | NOT HELD |

## What changes
| | Vault 2 | Vault 3 |
|---|---|---|
| Who reads the questions | nobody: they are turned into 384 numbers | a frontier model in Claude Desktop |
| Who searches | LanceDB on the laptop (MiniLM vectors) | still LanceDB on the laptop, called through MCP |
| Who chooses the chapters | the nearest numbers | the model, after searching and reading |
| What leaves the laptop | nothing | text only: the passages and chapters asked for (audited by `calls.sql`) |

## The prediction
With the laptop as librarian and a frontier model as reader, **all four threads are found: 4 of 4 held** under the Vault 2 rules.

| Q | Thread | Predicted chapters (unchanged) | Rule (unchanged) |
|---|---|---|---|
| Q1 | the watcher | 1, 7, 19, 24 | ≥ 3 of 4 in the model's top 4 |
| Q2 | the lie | 2, 5, 13, 21 | ≥ 2 of 4 |
| Q3 | the cost | 4, 5, 7 | ≥ 2 of 3 |
| Q4 | the door | 22, 23, 24 | ≥ 2 of 3 |

## Fair-test conditions
- The model sees the novel **only** through `novel_door`: four tools and 24 chapter files. It cannot see `SSOT.md`, the prediction files or the Machine Evidence table.
- Claude Desktop: web search **off**, no other connectors, memory **off**, reference past chats **off**, a new chat outside any project. The repository is public and holds the answers; the model must not be able to read it.
- The prompt is `spine/V3-PROMPT.txt`, pasted verbatim. Scoring is mechanical: `score.py` on the model's last four lines. Four different chapters per question.
- The model is not deterministic. **The one recorded run is the result.** It is not re-run for a better score.

## The door (second test)
The model proposes one SSOT amendment through `propose_ssot_amendment`.
**Predicted:**
1. Before sign-in, the tool is blocked: the smoke test prints `DOOR shut`, and the first real call returns *Authorization required*.
2. After the author's GitHub sign-in (through Arcade), an issue appears on `novel-ssot`.
3. `SSOT.md` is unchanged until the author commits a change that closes the issue.

## If something breaks on camera
Anything that fails during the take stays in the take and in this repository's history: it is fixed on camera, one change at a time, and named. Nothing is deleted from GitHub to tidy the record. If the reader's run is voided (it used the web, or a tool was refused), the void and its reason are stated aloud, and the next run in a new chat is the result.

## Scope and limits
Same four questions, one model, one take. This shows a division of labour (local retrieval, remote reading, human decision), not a benchmark. A held thread means the model's chapters match the author's, not that the model understands the book.
