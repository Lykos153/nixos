{
  programs.zsh = {
    initExtra = ''
      gesehen () {
        CDIR=$(pwd)
        DIR=$(dirname $1)
        FILE=$(basename $1)
        shift
        cd $DIR
        git annex metadata --tag gesehen -s gesehen+=`date '+%F@%H-%M'` $FILE $@
        cd $CDIR
      }

      film () {
        #ambi on
        vlc "$@"
        echo "Gesehen? "
        read yn
        case $yn in
          [YyJj]* ) gesehen "$@";;
        esac
        #ambi off
      }
    '';
  };
}
