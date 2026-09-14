# Translation structure and workflow (Vaino-book)

This book follows the model of `zig-book-FI`: one source, two language versions — without the R/knitr machinery.

## Principle: one source, two language versions

```
Vaino-book/
├── _quarto.yml          # ENGLISH book config (renders to _site/en)
├── index.qmd            # ENGLISH front page (source)
├── Chapters/            # ENGLISH — source of truth, edit here
├── Cover/               # SHARED — cover image
├── Figures/             # SHARED — figures
├── Assets/              # SHARED — theme, syntax definition, bibliography
├── landing/
│   └── index.html       # SHARED — language selector for the site root
│
├── fi/                  # FINNISH — the only place for translation work
│   ├── _quarto.yml      # Finnish book config (renders to _site/fi)
│   ├── index.qmd
│   └── Chapters/        # Translated .qmd files (same file name as EN)
│
├── scripts/
│   ├── translation-status.sh  # Show translation status
│   └── new-translation.sh     # Create a new translation skeleton
│
└── _site/               # PUBLISHED site (CI: en/ + fi/ + index.html)
```

## Daily workflow

### 1. Check translation status

```bash
./scripts/translation-status.sh
```

| Status | Meaning |
|--------|---------|
| `PUUTTUU` | English chapter has no translation |
| `VANHENTUNUT` | English `source_sha256` changed |
| `LUONNOS` / `draft` | Translation started but not finished |
| `VALMIS` | Translation matches current English version |

### 2. Create or update a translation

New chapter:

```bash
./scripts/new-translation.sh Chapters/01-vision.qmd
```

Update an outdated chapter:

1. Open the matching `fi/Chapters/*.qmd`
2. Diff against English (`git diff Chapters/foo.qmd`)
3. Update the translation (text, headings, captions — **do not** translate Zig code)
4. Refresh frontmatter:

```yaml
translation:
  source: Chapters/01-vision.qmd
  source_sha256: "<sha256sum Chapters/01-vision.qmd>"
  status: complete   # draft | in_progress | complete
```

### 3. Build and check locally

```bash
quarto render
cd fi && quarto render
```

### 4. Publish

Push to `main` → GitHub Actions renders both languages and deploys.

## What is translated and what is not

**Translated:** headings, prose, captions, footnotes, UI strings, book metadata (`fi/_quarto.yml`: title, subtitle).

**Not translated:** code blocks, `Zig` identifiers, file names, paths, `Assets/references.bib`.

## Figure paths (from `fi/`)

| Location | Path prefix |
|----------|-------------|
| `fi/index.qmd` | `../Figures/`, `../Cover/` |
| `fi/Chapters/*.qmd` | `../Figures/`, `../Cover/` |

`new-translation.sh` fixes these automatically.
