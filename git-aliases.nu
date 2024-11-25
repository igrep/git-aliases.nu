#!/usr/bin/env nu

const VERSION = "0.1.0"

def preview_generated_script [
  --except: list<string> = [],
  --prefix: string = "nongit-",
]: nothing -> string {
  let git_subcommands = git help -av |
    split row "\n" |
    each {
      ($in | parse --regex '^   (?<command>[-\w]+)').command.0?
    }

  let aliases = $git_subcommands |
    each {
      let command = $in
      if $command in $except {
        return
      }

      let already_defined = not (which $command | is-empty)
      let aliasCommand = $"alias ($command) = git ($command)\n"
      if $already_defined {
        $"alias ($prefix)($command) = ($command)\n($aliasCommand)"
      } else {
        $aliasCommand
      }
    } |
    str join ""
  $"($aliases)\n$env.GIT_ALIASES_ENABLED = true\n"
}

# Launch Nushell with aliases for all git subcommands so that you can use them without typing `git`.
# Tested in nu 0.100.0.
def main [
  --except: list<string> = [],
  # List of git subcommands not to make aliases for. E.g. `["commit", "push"]`.
  --prefix: string = "nongit-",
  # Prefix for aliases that conflict with existing commands. For example, git-aliases.nu makes `alias rm = git rm` by default, but to make the built-in `rm` command available, it makes an alias `nongit-rm = rm`.
  --preview,
  # Print the generated script instead of executing it.
  --version,
  # Print the version of the script.
]: nothing -> nothing {
  if ($version) {
    print $"git-aliases.nu ($VERSION)"
    return
  }

  let preview_src = (preview_generated_script --except=$except --prefix=$prefix)
  if ($preview) {
    print $preview_src
    return
  }

  nu --interactive --execute $preview_src
}
