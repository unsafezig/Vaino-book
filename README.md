# Väinö – AI-native OS in Zig / Tekoälynatiivi käyttöjärjestelmä Zigillä

Open bilingual book about the Väinö (Zinux) operating system: architecture, capability model, plugins, VSL, and hands-on labs — in English (`Chapters/`) and Finnish (`fi/Chapters/`).

- **Read (GitHub Pages):** root landing page with language selector → `/en/` and `/fi/`
- **Sources:** this folder is the Quarto project. English is the source language; Finnish mirrors it file-by-file.
- **OS sources:** `../../Zinux/docs/` (architecture, roadmap, specs) — the book summarizes and links, it does not fork the code.

## Build locally

Requires [Quarto](https://quarto.org/docs/get-started/) only — no R, no Zig needed for the book itself.

```bash
# English
quarto render
# Finnish
cd fi && quarto render
# Language landing page (copied by CI)
cp landing/index.html _site/index.html
```

Output: `_site/en/`, `_site/fi/`, `_site/index.html`.

## Translation workflow

```bash
./scripts/translation-status.sh
./scripts/new-translation.sh Chapters/01-vision.qmd
```

Rules (see [TRANSLATION.md](TRANSLATION.md)): translate prose, headings, captions. Do **not** translate code blocks, file names, paths, or identifiers. Update `translation.status` to `complete` and refresh `source_sha256` when done.

## Publish

Push to `main` → `.github/workflows/publish.yml` renders both languages, adds the landing page, and deploys `_site/` to GitHub Pages. PRs run `check.yml` (render only).

## License

CC-BY 4.0 — see [LICENSE](LICENSE). The OS itself (Zinux) is GPL-3.0-or-later; the Quarto structure is adapted from [pedropark99/zig-book](https://github.com/pedropark99/zig-book) (CC-BY 4.0).
