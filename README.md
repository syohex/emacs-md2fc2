# md2fc2.el

Markdown to fc2 format

## Rule

| Markdown            | fc2 HTML                            |
|:--------------------|:------------------------------------|
| `# foo`             | `<span style="font-size:x-large">`  |
| `## bar`            | `<span style="font-size:large">`    |
| `![title](foobar)`  | `<a href=".."><img src=".." /></a>` |
| `@@ URL`            | Product image                       |
