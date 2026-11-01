# NOVEL STRUCTURE — SSOT v1.0

## Identity & Scope
A 24-chapter literary novel about the cost of maintaining a comfortable
lie versus the terror of living without one.
Out of Scope: Plot twists for surprise. Magic realism. "Fixing" Chapter 1.

## Locked Decisions
| # | Decision | Rationale | Lock |
|---|----------|-----------|------|
| D1 | Ch 7 is the emotional anchor | Protagonist's old self dies here. | Do not move or soften. |
| D2 | The Figure never speaks | Meaning is projected by protagonist. | Do not give dialogue. |
| D3 | Ch 1 and Ch 24 mirror each other | Meaning inverted. | Do not add new images. |
| D4 | The Lie is the true antagonist | "I chose this life." | Do not externalise the enemy. |
| D5 | Sarah's pressure enters the home | From Ch 4 she comes to the kitchen (car-share). | Kitchen scenes, not office, for Ch 4–5. |

## Frozen Constants
- The Lie: "I chose this life." (The truth: they fled into it.)
- The Echo: "I wonder if they ever leave that room." (Ch 1 → Ch 7)
- The Figure appears in Chapters 1, 7, 19, and 24. Only.
- Emotional pillars: Chapters 1, 7, 13, 19. (Not the same list as the Figure.)
- The protagonist is always slightly cold. Wears an extra layer.
- Sarah's key line is spoken in Chapter 5.
- The letter is locked in the middle dresser drawer from Ch 4 to Ch 13.

## Emotional Spine
The novel is about the cost of maintaining a comfortable lie versus
the terror of living without one. Every chapter must serve this spine.

## Pacing Rule
- Chapters 1, 7, 13, 19 are the emotional pillars. They must land with
  full force.
- The chapters between pillars are connective tissue. They build tension
  but do not resolve it.
- Chapter 7 is the most important chapter in the novel. It is where the
  protagonist's old self dies. Everything after is aftermath.
- Chapter 2 must establish the routine as a defence mechanism. The precision is not calm. It is armour.

## Leviathan Lock
The AI is FORBIDDEN from:
- Rewriting Chapter 1 prose
- Altering the Frozen Constants
- Moving the emotional pillars to different chapters
- Giving dialogue to the Figure in the Window

## Machine Evidence (spine run 20261101_171405, vector-snake 2.0.0, all-MiniLM-L6-v2, max_chars 800)
| Thread | Predicted | Observed top 4 | Verdict |
|---|---|---|---|
| The watcher | 1 · 7 · 19 · 24 (≥ 3) | 1 · 7 · 24 · 19 | HELD (4 of 4) |
| The lie | 2 · 5 · 13 · 21 (≥ 2) | 7 · 13 · 8 · 3 | NOT HELD (1) |
| The cost | 4 · 5 · 7 (≥ 2) | 14 · 2 · 21 · 6 | NOT HELD (0) |
| The door | 22 · 23 · 24 (≥ 2) | 10 · 11 · 5 · 24 | NOT HELD (1) |

Rule: evidence informs; it does not decide. The Frozen Constants are the author's.

## Changelog
| Version | Date | Change | Reason |
|---------|------|--------|--------|
| v1.0 | 2026-10-30 | Initial SSOT, with the spine run's evidence | Project genesis |
