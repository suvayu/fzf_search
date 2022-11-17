# Ripgrep + FZF

```
$ fzf-search [query]
```
Search a source tree recursively with `rg` and `fzf`.

When you are working in a large repository/working directory,
searching for blocks of text in hundreds of files can be difficult.
This Ripgrep user-interface using FZF addresses that by leting you
narrow down your search results by letting you search recursively with
a set of files restricted further by the previous search.  You easily
switch between searching file contents to filtering file paths.  Here
is a mini screencast demonstrating some of these features.

![screen cast of using fzf-search](./fzf-search-demo.gif)

**PS:** You can access a cheat-sheet by pressing <kbd>F1</kbd> at any point.

### Keybindings

- <kbd>F1</kbd> help message
- <kbd>C-s</kbd> search source tree recursively
- <kbd>C-f</kbd> limit files to search
- <kbd>RET</kbd> - open in a pager (`bat`)
- <kbd>M-RET</kbd> - open in `$EDITOR`

### Dependencies

- `rg` for search
- `fzf` for display & filtering UI
- `bat` for preview
