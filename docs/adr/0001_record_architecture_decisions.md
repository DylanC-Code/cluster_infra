# 0001: Record architecture decisions

Status: Accepted (2026-11-11)

## Context

The cluster is run by one person and rebuilt from Git. Months later, the
reason behind a structural choice is easy to forget, and easy to undo by
accident.

## Decision

Every structural decision is recorded in `docs/adr/` as a short file:
context, decision, consequences. Changing a decision means writing a new
ADR that supersedes the old one, never rewriting history.

## Consequences

- Adding a platform category, changing a layer rule or replacing a core
  tool requires an ADR in the same pull request.
- The ADR list doubles as a summary of how and why the cluster is built.
