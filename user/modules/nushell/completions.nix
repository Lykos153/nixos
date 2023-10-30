{pkgs, ...}: {
  programs.carapace.enable = true;
  programs.carapace.enableNushellIntegration = false;
  programs.nushell = {
    extraConfig = ''
      let carapace_completer = {|spans|
          carapace $spans.0 nushell $spans | from json
      }
      let fish_completer = {|spans|
          ${pkgs.fish}/bin/fish --command $'complete "--do-complete=($spans | str join " ")"'
          | $"value(char tab)description(char newline)" + $in
          | from tsv --flexible --no-infer
      }
      let external_completer = {|spans|
        # workaround for https://github.com/nushell/nushell/issues/8483
        let expanded_alias = (scope aliases | where name == $spans.0 | get -i 0 | get -i expansion)
        let spans = (if $expanded_alias != null  {
            # put the first word of the expanded alias first in the span
            $spans | skip 1 | prepend ($expanded_alias | split row " ")
        } else { $spans })
        # end workaround

          match $spans.0 {
              nu => $fish_completer
              git => $fish_completer
              _ => $carapace_completer
          } | do $in $spans
      }

      $env.config.completions.external = {
        enable: true
        completer: $external_completer
      }
    '';
  };
}
