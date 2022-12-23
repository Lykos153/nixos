{
  #TODO: if zsh is used
  programs.zsh = {
    shellAliases = {
      # Just a bit shorter to type
      tw = "timew";

      # Start of business. Adds a zero-length interval with start=end=now. This is the first command I type when I start working. Useful in conjunction with `twnow` and `twdone`. Alternative (and maybe a bit more cheerful) names: hi, moin, howdy, gmornin, you name it...
      sob = "timew track $(date +%FT%T -d@$(expr $(date +%s) - 1)) - $(date +%FT%T) sob";

      # End of business. Adds a zero-length interval to denote the end of your working day. Useful because (1) it stops the currently active tracking and (2) if you don't have an active tracking, it helps you to reverse-engineer your day afterwards. Alternative names: cya, gnight
      eob = "timew stop >/dev/null; sleep 1; timew track $(date +%FT%T -d@$(expr $(date +%s) - 1)) - $(date +%FT%T) eob";

      twcont = "timew start >/dev/null && timew join @1 @2 && timew; :";

      afk = "timew stop && timew continue >/dev/null && timew tag afk >/dev/null; timew; :";
      re = "timew stop && timew continue >/dev/null && timew untag afk >/dev/null; timew; :";
      pause = "timew start pause";
      twids = "timew summary :ids";

      # Open the current month in $EDITOR and clear the tag database. (If you edit tags, the tag database may become inconsistent. It will be re-generated on the next invocation of timew.)
      twedit = ''$EDITOR "''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/$(date +%Y-%m.data)"; rm -f ''${TIMEWARRIORDB:="$HOME/.timewarrior"}/data/tags.data; timew &>/dev/null; :'';
    };
  };
  home.file.".timewarrior/extensions".source = ./extensions;
  home.file.".timewarrior/extensions".recursive = true;
  home.file.".local/bin/tw-note".source = ./utils/tw-note;
}
