# git-sh.nu

Configure aliases for all git subcommands so that you can use them without typing `git`.

## Installation

Download from [GitHub](https://github.com/igrep/git-aliases.nu/raw/refs/heads/main/git-aliases.nu) and save it to your `PATH`, then `chmod +x` it.

## Usage

See `git-aliases.nu --help`.

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
