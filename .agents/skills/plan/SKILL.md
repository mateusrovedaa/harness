---
name: plan
description: "Write an implementation plan to PLAN.md before touching code. Use when the task spans more than one file, has real ambiguity, or when the user asks for a plan or to think before doing. Replaces closed-harness plan mode with a versioned file."
---

# Plan before implementing

Plan mode does not need to be a harness feature: a file does the job, and it stays
in git history for review.

## When to use

- The change touches more than one file.
- The task statement has real ambiguity (more than one defensible reading).
- The task is risky or hard to revert.

A single-file task with a clear statement does NOT need a plan. Writing one for it
is ceremony.

## Procedure

1. **Read before proposing.** Locate the files involved and read the relevant
   parts. A plan written without reading the code is a formatted guess.

2. **Write `PLAN.md`** with this structure:

   ```markdown
   # <task>

   ## Understanding
   What will be done, in two or three sentences.

   ## Ambiguities
   What the statement leaves open, and the reading I will adopt.
   If an ambiguity changes the outcome, STOP and ask instead of choosing.

   ## Steps
   1. file:line — what changes and why
   2. ...

   ## Verification
   The exact command that proves it worked.

   ## Out of scope
   What I could have touched and deliberately will not.
   ```

   Every step must carry its real content. Placeholders are plan failures:
   "TBD", "add appropriate error handling", "handle edge cases", "similar to
   step N". If you cannot write a step concretely, you have not read enough
   code — go back to 1.

3. **Self-review before showing.** Three checks on what you just wrote:
   - Coverage: point to the step that implements each part of the request.
   - Placeholder scan: search for the patterns above; fix inline.
   - Name consistency: files, functions, and types used in later steps must
     match what earlier steps define.

4. **Show the plan and wait.** Do not start implementing in the same turn.

## Cost tip

Planning benefits from a strong model; implementing a good plan tolerates a cheap
one. If the harness can switch models mid-session (`/model` in pi), plan with the
expensive model and implement with the cheap one — the plan is what carries the
intelligence into the next step.

## Rationalizations

| Excuse | Reality |
|---|---|
| "A thorough plan shows care" | A 40-line plan for a 3-line change is ceremony. Match plan size to task size. |
| "Running the tests is a step" | That is the verification, not the work. |
| "Flagging ambiguity looks careful" | Invented ambiguity wastes a round trip. If it is clear, say it is clear. |
