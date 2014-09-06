## dotfiles

My dotfiles based on [Zach Holman](https://github.com/holman)'s [dotfiles](https://github.com/holman/dotfiles) philosophy. However, there's plenty of stuff from [Hashrocket](https://github.com/hashrocket)'s [dotmatrix](https://github.com/hashrocket/dotmatrix).

## install

Run this:

```sh
git clone https://github.com/therubymug/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane OS X
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of what's inside is just aliases: `gst` for `git status`, `gpr` for `git
pull --rebase --prune`, for example. You can browse the `aliases.zsh` files in
each topic directory. There's also a collection of scripts in `bin` you can
browse.

## thanks

I forked [Zach Holman](http://github.com/holman)'s
[dotfiles](http://github.com/holman/dotfiles) and basically adopted his philosophy
but made it work with my preferred environment tools.
A decent amount of the code in these dotfiles stems either from Hashrocket's Dotmatrix, Holman's dotfiles or by extension,
Ryan Bates' original dotfiles.
