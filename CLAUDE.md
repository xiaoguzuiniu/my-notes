# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A single-page note-taking web app ("记事本", Chinese UI) that stores notes in `localStorage` and syncs them to GitHub. The entire app — HTML, CSS, JS — lives in `index.html` (~1600 lines). There is **no build system, no package manager, no tests, no lint**.

To run: open `index.html` directly in a browser, or serve the directory with any static file server (e.g. `python -m http.server`).

## Architecture

**One-file app**: `index.html` contains all markup, styles (inline `<style>`), and logic (inline `<script>`). All edits to UI, behavior, or styling happen in this file.

**Two storage layers** (kept in sync):
- **Local**: `localStorage` keys `notes`, `categories`, `githubConfig`. Loaded at startup, written on every edit (debounced 1s).
- **Remote**: `data.json` at the root of a GitHub repo, updated via the GitHub Contents API (`PUT /repos/{repo}/contents/{file}`). Sync is debounced 2s after edits. The app tracks `fileSha` from the last API response and includes it in subsequent updates for optimistic concurrency.

**Data shape** (`data.json`):
```json
{ "notes": [{ "id", "title", "content", "category", "createdAt", "updatedAt" }],
  "categories": ["未分类", ...],
  "updatedAt": "..." }
```

**File uploads** (the "📁 文件管理" modal) use a separate path: files are uploaded to a GitHub Release tagged `files` via the Releases API, supporting up to 2 GB per file. This is unrelated to note sync.

## Critical: `data.json` is auto-generated

`data.json` in this repo is **written by the running app** through the GitHub API, not hand-edited. The git history is full of `sync: update notes` commits from app sync events. **Do not hand-edit `data.json` and commit it** unless explicitly asked — the next app sync will likely conflict (stale `fileSha`) and may overwrite changes. If a manual edit is unavoidable, the next browser load of the app will reload from the remote and surface conflicts via sync errors.

## GitHub token in source

The default GitHub PAT is intentionally baked into `index.html` (split across `_t1`..`_t6` string fragments at ~line 753 to evade scanners), pointing at `xiaoguzuiniu/my-notes`. Treat this token as a real secret:
- Don't echo, log, or paste it into other files.
- Users can override the token/repo/file via the in-app Settings modal; overrides are persisted to `localStorage.githubConfig`.

## Where things live in `index.html`

- Lines ~7–660: `<style>` — all CSS, including a `@media (max-width: 600px)` mobile layout block. The sidebar becomes a slide-out drawer on mobile.
- Lines ~660–737: markup (toolbar, sidebar, editor, settings modal, files modal).
- Lines ~740–1616: `<script>` — state, render functions, GitHub sync, file upload/list/delete.
- `init()` runs at the bottom of the script and is the entry point: load local → if GitHub configured, fetch remote and overwrite local → select first note.

## Other files in the repo

- `diagrams/*.drawio`, `images/*.png` — assets referenced from note content (e.g. embedded links/images inside a note), not loaded by the app itself.
- `.claude/` — local Claude Code config, should not be committed.
