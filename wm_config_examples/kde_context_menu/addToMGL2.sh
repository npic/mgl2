#! /bin/sh -e

TARGET="$1"
DBFILE=`kdialog --title "Select DB entry file" --getsavefilename /your/MGL2/database.db/`
SHORT_DBFILE=`basename -- "$DBFILE"`
INIT_CONTENTS=`printf -- "Title: $SHORT_DBFILE\nCommand: $TARGET"`
CONTENT=`kdialog --textinputbox "MGL2 entry:" "$INIT_CONTENTS"`

printf -- "$CONTENT" > "$DBFILE"

