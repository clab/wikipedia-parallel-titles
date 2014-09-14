#!/bin/bash
set -e
set -o pipefail

ROOTDIR=`dirname $0`
SCRIPTS=$ROOTDIR/scripts


if [[ $# == 2 ]] ; then
    TARGET=$1
    INPUT=$2
else
    echo Usage: $0 en fawiki-20120201 1>&2
    exit 1
fi

echo Target language code: $TARGET 1>&2

LANGLINKS=$INPUT-langlinks.sql.gz
PAGES=$INPUT-page.sql.gz

if [[ -f $LANGLINKS ]]; then
  echo Using $LANGLINKS 1>&2
else
  echo Could not find $LANGLINKS 1>&2
  exit 1
fi

if [[ -f $PAGES ]]; then
  echo Using $PAGES 1>&2
else
  echo Could not find $PAGES 1>&2
  exit 1
fi

$SCRIPTS/extract.pl $TARGET $PAGES $LANGLINKS | $SCRIPTS/utf8-normalize.sh | $SCRIPTS/postprocess-list.pl | LANG=C sort -u

