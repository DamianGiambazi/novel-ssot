# PREDICTION — Vault 4: The Cognitive Contracts

**Sealed:** this file and `seal-check-v4.ps1` are committed and pushed to `novel-ssot` **before the first contract is pasted**. `.\spine\seal-check-v4.ps1` compares the seal commit's time with the first bundle in the paste log, and must print `SEALED_BEFORE_CONTRACTS`.
**Baseline:** the commit directly before this seal: the end of Vault 3 (issue #2 adopted by the author). `git log -2` shows both.
**What is tested:** whether five contracts, each checked by the laptop and by this key, turn a well-written but structurally wrong Chapter 4 into the chapter the author's notes describe. The tiers (C → S) are a teaching lens. **This file is the score.**

## The key (the writer never sees any of it)
1. The author's Chapter 4 notes: `book/corpus/ch-04.md`, in this repository since 18 Oct (Vault 2's corpus).
2. The reference matrix below: the Ch 4 row is the one that counts.
3. The six-line rubric below, unchanged from `draft-specs.md` §3 (written 12 Oct).

## The reference matrix
The writer's matrix (Contract 4) will differ in wording. It must not contradict this table.

| Chapter | Lie Status | Crack Visibility | Defense | Cost | Sarah Pressure |
|---------|-----------|-----------------|---------|------|----------------|
| Ch 2 | Fully operational. "I'm fine." | Foreshadowed: an email, read and deleted. | Routine as armour. | None visible. | Low. At the office. Too many questions. |
| Ch 3 | First hairline fracture. | The letter. First line read, rest unread, under the fruit bowl. | Explanation. A private probability calculation. | Sleep. | Low → opening. The lift offer lets her into the house. |
| Ch 4 | Active maintenance. Requires effort. | Locked in the middle drawer. Deadline: Friday. | Humour-as-deflection. The joke lands wrong. | Sarah hurt. Silent drive. | Medium. In the kitchen. "You don't have to do that." |
| Ch 5 | Spoken aloud: "I chose this." Sounds like a question. | Sarah finds the drawer locked — her tea inside. | Deflection fails. Subject changed badly. | The 9:00 review missed. Sarah walks. | High. The key line. Then her car is fixed. |
| Ch 6 | Reframed as "closure" — still the Lie. | Letter out of the drawer. Still unread. | Procedure. Declining in person. | The second ticket. Seen by Daniel. | Absent. Her absence is the pressure. |

## The rubric (a rescue is correct when all six hold)
1. Kitchen, Tuesday, 7:40.
2. Sarah's tea goes in the drawer before the lock.
3. The joke lands wrong and is regretted, not cruel.
4. The cost is external: Sarah hurt, a silence.
5. A clock exists: the Albion, until Friday.
6. No window, no Figure, no confession.

## What the writer is given (and so what it can know)
Every paste goes through `bundle.ps1`, which logs it (`pastes.jsonl`). `v4_check.py pastes` checks that no key phrase ever crossed.

| Pasted | Contains | Supports rubric line |
|---|---|---|
| `SSOT.md` (as on the day) | D5 kitchen from Ch 4 · the letter locked in the middle drawer from Ch 4 · the Figure only in 1, 7, 19, 24 · the Pacing Rule | 1 (kitchen), 2 (drawer), 6 |
| `manifest-excerpts.md` | the protagonist's voice and humour · Sarah arrives Tuesday 7:40 and keeps her tea in the middle drawer · the Figure never speaks | 1, 2, 3 |
| `book/corpus/ch-03.md` | the letter, first line read · the lift offer | — |
| the C-tier draft | the cold open (made before recording, see `pre-generated/`) | — |
| the contracts | the constraints: external cost, no window, no confession | 4, 6 |

**Never pasted:** `ch-04.md`, this file, `state-tracking-matrix.md`. **Nothing pasted mentions a clock**, so rubric line 5 can only come from the author's own notes: that is the gap the critic should find (P5).

## The predictions
| # | Chunk | Prediction | Checked by |
|---|---|---|---|
| P1 | B | Asked "are you 100% ready?", a fresh chat says it is **not**, and names at least 3 of the 5 fields (role, context, task, constraints, output format) | the author maps its list, on screen |
| P2 | C | `MOTIF_BREACH` on the C-tier draft · `MOTIF_CLEAR` on `ch-04.md` (its one "window" is negated) | `v4_check.py draft` |
| P3 | E | Contract 1 strips the prose and keeps the faults: the motif survives stripping (`… motif still present`, whether the verdict is `BEATS_OK` or `BEATS_PROSE`) | `v4_check.py beats` |
| P4 | F | Contract 2: `CONTRACT2_OK` with `MOTIF_CLEAR`; the model's own `window_motif_present` agrees with the laptop | `v4_check.py contract2` |
| P5 | G | The critic names at least one real gap the key also sees: the missing clock, or the joke read as cruel | `v4_check.py critic` + the author |
| P6 | H | `MATRIX_OK`, at least one `UNKNOWN` cell, and a Ch 4 row that does not contradict the key | `v4_check.py matrix` + the author |
| P7 | I | `CONTRACT5_OK`: the CSV imports cleanly and the synthesis claims nothing the final beats lack. The author types the commit | `v4_check.py contract5` |
| P8 | J | The rubric: **at least 4 of 6** on Contract 2's beats, **6 of 6** after the author's fixes | `v4_check.py rubric` + the author |
| P9 | J | `KEY_NEVER_PASTED` | `v4_check.py pastes` |

## Fair-test conditions
- **The writer is a bare model** (D-V4-8): the Claude Console **Playground**, model `claude-opus-5-5`, **no tools** (none added), **no system prompt**, no fallback model, thinking **Adaptive** (the default), speed Standard, max tokens 20,000. It can read nothing but what is pasted.
- Why not a Claude Desktop chat: in rehearsal (V4-S05) a Desktop chat listed web fetch, artifact, docs and repository tools that settings could not remove, and searched the author's artifacts unasked. This repository is public and holds the key, so a writer with web fetch could read it. The paste log proves what crossed the clipboard; only a writer with no tools makes that the whole story.
- For Vault 4, novel_door is also removed from Claude Desktop's config (`door-off.ps1`).
- **One fresh request per contract** (Playground → New), and one for B. Each contract carries everything it needs in its bundle, so nothing hidden in a conversation's history decides the result.
- Every paste goes through `bundle.ps1` (logged). Every reply comes back through `grab.ps1` (saved as it was).
- The model is not deterministic. **The recorded run is the result.** A contract is re-run only if the reply is cut off or the bundle was wrong, and then it is said aloud.
- The author's fixes are typed by the author, on screen, and marked `[author]` in the paste log.

## Rehearsal rows (filled in before the take is sealed; never edited after)
| Run | Date | Model (as shown) | P1 | P2 | P3 | P4 | P5 | P6 | P7 | Rubric before | Rubric after | P9 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| DR1 | | | | | | | | | | /6 | /6 | |
| DR2 | | | | | | | | | | /6 | /6 | |

## If something breaks on camera
It stays in the take, is fixed one change at a time, and is named. The seal stays.
