# Offline verification boundary

Collect all diagnostic failures instead of stopping at the first; default read-only mode skips runtime commands and avoids eval.

## Reproduce

`python3 -m unittest discover -s tests -v`

--include-runtime is explicit. Read-only mode inspects the persistent SQLite header rather than opening SQLite, and reports runtime checks NOT_RUN. Host health cannot be inferred from skipped live checks.

## Rollback

Review the commit diff and use a new checkout of the pre-change commit for source rollback. Keep user data and live installations untouched. A source rollback is not permission to restore unsafe network exposure or bypass approval.
