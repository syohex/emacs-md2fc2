# md2fc2.el

Markdown to fc2 format

## Convertion Rules

| Markdown            | fc2 HTML                            |
|:--------------------|:------------------------------------|
| `# foo`             | `<span style="font-size:x-large">`  |
| `## bar`            | `<span style="font-size:large">`    |
| `![title](foobar)`  | `<a href=".."><img src=".." /></a>` |
| `@@ URL`            | Product image                       |

## Customization

##### `md2fc2-dmm-account`

Append dmm affiliate account to URL
