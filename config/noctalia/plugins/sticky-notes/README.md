# 📝 Sticky Notes

Sticky Notes is a lightweight sticky notes plugin for [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell), like OneNote's Sticky Notes but support **Markdown**.

It allows you to quickly jot down thoughts, code snippets, and to-do lists in beautiful pastel-colored floating cards straight from your system bar.

---

## 📸 Screenshots

<img src="screenshot.png" width="350" title="sticky notes">

---

## ✍️ Supported Markdown Syntax

- **Headers**: Standard `# h1` to `###### h6` as well as Setext style headers (`===` and `---` underlines).
- **Text Emphasis**: `**Bold**`, `*Italic*`, `__Bold__`, `_Italic_`, and `~~Strikethrough~~`.
- **Lists** (Fully nested visual indents):
  - Unordered (`-`, `*`, `+`)
  - Ordered (`1.`, `2.`, `3.`)
  - Task lists (`- [x] Done`, `- [ ] Pending`) with automatic strikethrough styling for completed tasks.
- **Blockquotes**: Support for standard `> Quote` and nested blockquotes `> > > Deep Quote`.
- **Code**:
  - `Inline code` highlighting.
  - Multi-line ```` Code blocks ```` with smooth gray backgrounds.
  - 4-space indented code blocks.
- **Links & Images**:
  - Inline Links: `[Noctalia](https://example.com "Title")`
  - Inline Images: `![Alt Text](url "Title")` (Large images intelligently cap at 280px to protect UI geometry).
  - Reference Links/Images: `[Link][id]` coupled with `[id]: url`.
  - Autolinks: `<http://example.com>` or `<email@example.com>`.
- **Data Tables**: Standard GFM (GitHub Flavored Markdown) structured tables with alignment:
  ```markdown
  | Option | Description |
  | :--- | ---: |
  | Left | Right |
  ```
- **Horizontal Rules**: Supports `---`, `***`, and `___`.
- **Backslash Escapes**: Prevents rendering of literal markdown characters `\*`, `\` etc.

---
