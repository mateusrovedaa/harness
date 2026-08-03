---
name: cross-review
description: "Review the current diff with a model from ANOTHER vendor, to catch what the model that wrote the code cannot see. Use before shipping a change, before opening a PR, or when the user asks for a review, code review, or second opinion."
---

# Cross-review with another vendor's model

Different models have different failure modes. The model that wrote the code is
its worst reviewer: it already believes its own solution. Switching vendors for
the review catches the class of error the same family repeats.

## Procedure

1. **Gather the material.** The diff is the unit of review:

   ```sh
   git diff HEAD          # or: git diff <base>...HEAD
   ```

2. **Call a model from another vendor.** One-shot, no TUI:

   ```sh
   git diff HEAD | pi --provider openai --model <model> -p "$(cat <<'EOF'
   Review this diff as a skeptical reviewer. Report only problems, each with
   file:line and the concrete failure scenario (specific input -> wrong
   output). If there is no real problem, say so in one line.
   Focus on: correctness, unhandled edge cases, swallowed errors, and changes
   outside the requested scope.
   EOF
   )"
   ```

   Set `--provider`/`--model` to a vendor DIFFERENT from the one that produced
   the code. If the code came from an Anthropic model, review with OpenAI, and
   vice versa. A local model works for cheap review of a small diff.

3. **Triage before acting.** A skeptical reviewer produces false positives. For
   each finding, confirm it by reading the code before changing anything. A
   finding you cannot mentally reproduce is not an edit — it is a question.
   Rank what survives:

   - **Critical** — wrong output, data loss, security: fix now.
   - **Important** — unhandled edge case, swallowed error: fix before shipping.
   - **Minor** — style, naming: note it; it does not block the delivery.

4. **Report** what the reviewer found, what you confirmed, and what you
   discarded, with reasons.

## Why one-shot

The review must be independent: clean context, without the history of whoever
wrote the code and without the justifications already given. A contaminated
session reviews the reasoning, not the result.

## Common objections

| Excuse | Reality |
|---|---|
| "One call can review and fix" | Reviewing and fixing together makes the model justify its own changes. Separate calls. |
| "The reviewer sounded confident" | Applying a suggestion blindly trades one bug for another. Confirm it in the code first. |
| "The same model is already configured" | It already believes its own solution — the case this skill exists to prevent. |
