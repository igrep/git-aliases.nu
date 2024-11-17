#!/usr/bin/env nu

def "preview-generated-aliases" [
  --except: list<string> = [],
  --prefix: string = "nongit-",
]: nothing -> string {
  let git_subcommands = git help -av |
    split row "\n" |
    each {
      ($in | parse --regex '^   (?<command>[-\w]+)').command.0?
    }

  $git_subcommands |
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
}

def main [
  --except: list<string> = [],
  --prefix: string = "nongit-",
]: nothing -> nothing {
  nu --interactive --execute (preview-generated-aliases --except=$except --prefix=$prefix)
}
