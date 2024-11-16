export const generated_overwrite_nu_path = $"($nu.data-dir)/git-sh-overwrite.nu"

export def "preview-generated-aliases" [
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

export def "generate-overwrite-nu" [
  --except: list<string> = [],
  --prefix: string = "nongit-",
]: nothing -> nothing {
  mkdir $nu.data-dir
  preview-generated-aliases --except=$except --prefix=$prefix |
    save -f $"($nu.data-dir)/git-sh-overwrite.nu"
}


