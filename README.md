# git-sh.nu

Configure aliases for all git subcommands so that you can use them without typing `git`. Inspired by [git-sh](https://rtomayko.github.io/git-sh/).

## Installation

Download from [GitHub](https://github.com/igrep/git-aliases.nu/raw/refs/heads/main/git-aliases.nu) and save it to your `PATH`, then `chmod +x` it.

## Usage

Just run  `git-aliases.nu`, then the `nu` command starts with the aliases configured. Now you don't need to type `git` before the subcommands:

```nu
> git-aliases.nu

> branch
* main

> status
On branch main
Your branch is up to date with 'origin/main'.

...
```

And `git-aliases.nu` sets an environment variable `GIT_ALIASES_NU` to `true`. It's useful for switching the prompt. For example, you can add the following to your `$nu.env-path` (usually `~/.config/nushell/env.nu`):

```nu
def create_left_prompt [] {
  if ($env.GIT_ALIASES_ENABLED? == true) {
    return $"(left_prompt_when_git_aliases_enabled)\n:"
  }

  ...
}
```

See `git-aliases.nu --help` for more.

## Known Issue

The `--prefix` option to the built-in commands is not working as expected. For example:

```nu
> nongit-rm --help
Error: nu::shell::nushell_failed_spanned

  × Nushell failed: Can't run alias directly. Unwrap it first.
   ╭─[entry #3:1:1]
 1 │ nongit-rm --help
   · ────┬────
   ·     ╰── originates from here
   ╰────
  help: This shouldn't happen. Please file an issue: https://github.com/nushell/nushell/issues
```
