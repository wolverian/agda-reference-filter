This is a literate Agda file.

Here's some inline code:

- This is a link to the record below: `Record`{.agda}
- This is not: `Record`
- This is a link with alternate text: `also a link`{.agda ident=Record}

```agda
record Record : Set where
  constructor hey-look
```