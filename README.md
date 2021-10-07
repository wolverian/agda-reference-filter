# agda-reference-filter

A Pandoc filter for linking Agda identifiers in inline code blocks.

## Usage

Compile your literate Agda file to Markdown (use `--html-highlight=auto`), then `pandoc --filter agda-reference-filter -i output.md -o output.html` to compile the Markdown to HTML. Inline code spans that are exactly the same as an identifier present in the raw HTML emitted by Agda (that is - either a definition or a reference) will be linked to the same place that Agda linked that identifier to.

```bash
agda --html-highlight=auto --html example.lagda.md
pandoc --filter agda-reference-filter -i example.md -o example.html
```