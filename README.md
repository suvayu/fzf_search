# Ripgrep + FZF

```
$ fzf-search [query]
```
Search a source tree recursively with `rg` and `fzf`.

When you are working in a large repository/working directory,
searching for blocks of text in hundreds of files can be difficult.
This FZF interface for Ripgrep addresses that by letting you narrow
down your search results recursively.  A search is restricted to the
set of files with matches in the previous step.  At any point, you can
easily switch between searching file contents or filtering file paths.
Here is a mini screencast demonstrating some of these features.

![screen cast of using fzf-search](./fzf-search-demo.gif)

**PS:** You can access a cheat-sheet by pressing <kbd>F1</kbd> at any point.

## Keybindings

- <kbd>F1</kbd> help message
- <kbd>C-s</kbd> search source tree recursively
- <kbd>C-f</kbd> limit files to search
- <kbd>RET</kbd> - open in a pager (`bat` or `less`)
- <kbd>M-RET</kbd> - open in `$EDITOR`

## Example commands

- Find files in a directory to search:
  ```shell
  $ fzf-file <directory>
  ```
- Search the current directory:
  ```shell
  $ fzf-search <query>
  ```

## Dependencies

- [Ripgrep](https://github.com/BurntSushi/ripgrep/) or `rg` for search
- [`fzf`](https://github.com/junegunn/fzf) for display & filtering UI
- (optional) [`bat`](https://github.com/sharkdp/bat) for preview.
  It's a `cat` clone with syntax highlighting support.  If it isn't
  found in `$PATH`, `less` is used.
- `man` to see the help message

## Installation

You need to install the above dependencies using your platform's
package manager.  After that you have to make sure the scripts in this
repo are in your `$PATH`.  There are several ways you could achieve
this:

1. Checkout this repo, and add it to your `$PATH`

   ```shell
   $ git checkout https://github.com/suvayu/fzf_search.git
   $ export PATH="$PWD/fzf_search:$PATH"
   ```

   To make this permanent, set this value of `$PATH` in your shell's
   profile/rc file.  For Bash that would be `~/.bash_profile` or
   `~/.bashrc`.

2. Checkout this repo, and create symlinks to the scripts in a
   directory that is present in your `$PATH`.  Say `~/bin` is in your
   `$PATH`.
   
   ```shell
   $ git checkout https://github.com/suvayu/fzf_search.git
   $ cd ~/bin
   $ ln -s $OLDPWD/fzf_search/fzf-{search,file} .
   ```

2. Copy over the scripts (`fzf-{search,file}`) and `help.1` to a
   directory in your `$PATH`.  Note that when copying the files you
   also need to copy the help file to be able to see the help message.
   This is because scripts try to find the help file in the same
   directory.

Out of the above methods, (2) is preferred if you already have a setup
where you have a user directory in your `$PATH`, however if that's not
the case, (1) is a somewhat simpler alternative.  While (3) works, it
is discouraged as it's difficult to update the scripts.

### Updating

If you have followed options (1) or (2) to install the scripts, you
may update by navigating to the git repository, and running `git
pull`.  If you opted for option (3) to install, you need to reinstall.
