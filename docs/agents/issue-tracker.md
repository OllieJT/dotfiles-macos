# Issue tracker: GitHub

Issues and specs live in GitHub Issues for `OllieJT/dotfiles-macos`.
Use the `gh` CLI from this repository.

## Conventions

- Before creating issues, verify the target with
  `gh repo view --json nameWithOwner`.
  Use `--repo OllieJT/dotfiles-macos` if the inferred target differs.
- Create: `gh issue create --title "..." --body-file <file>`.
  Use a file for multiline bodies.
- Read: `gh issue view <number> --json number,title,body,labels,comments`.
- List: `gh issue list --state open`, with appropriate label filters.
- Comment: `gh issue comment <number> --body-file <file>`.
- Apply or remove labels:
  `gh issue edit <number> --add-label "..."` or `--remove-label "..."`.
- Close: post the explanation as a comment, then
  `gh issue close <number>`. Post comments separately even when
  the issue is already closed.

File issues only in the user's repository.

## Parent issues and blockers

Use native GitHub sub-issues and issue dependencies when available.
Otherwise, put `Part of #<parent>` and `Blocked by: #<number>` at the
top of the child body, and list children in the parent's task list.

An issue is unblocked when all its blockers are closed.

## Pull requests as a triage surface

**PRs as a request surface: no.**

## Skill terminology

“Publish to the issue tracker” means create a GitHub issue.
“Fetch the relevant ticket” means read the GitHub issue.

## Wayfinding operations

The map is one issue labelled `wayfinder:map`, containing Notes,
Decisions-so-far, and Fog. Child tickets link to it as sub-issues
or through the parent conventions above.

Use `wayfinder:<type>` for research, prototype, grilling, or task tickets.
Choose the first open, unassigned, unblocked child in map order.
Claim it with `gh issue edit <number> --add-assignee @me`.
Resolve it by commenting with the answer, closing it, and adding a
summary and link to the map's Decisions-so-far.
