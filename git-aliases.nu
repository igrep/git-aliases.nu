#!/usr/bin/env nu

def "preview-generated-script" [
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

def main [
  --except: list<string> = [],
  --prefix: string = "nongit-",
]: nothing -> nothing {
  nu --interactive --execute (preview-generated-script --except=$except --prefix=$prefix)
}
