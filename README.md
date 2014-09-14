wikipedia-parallel-titles
=========================

This document describes how to use these tools to build a parallel corpus (for a specific language pair) based on article titles across languages in Wikipedia.

#### Download necessary data

Wikipedia publishes database dumps of their content periodically. To run these scripts you need two files per language pair: the base per-page data, which includes article IDs and their titles in a particular language (ending with `-page.sql.gz`) and the interlanguage link records (file ends with `-langlinks.sql.gz`). To find these files, go to the [Wikimedia Downloads page](http://dumps.wikimedia.org/backup-index.html) and find the database dump for the Wikipedia in *one* of the languages in the pair (the smaller one is recommended since it will make processing faster). The database backup are named by pairing the [ISO 639 code](http://en.wikipedia.org/wiki/List_of_ISO_639-2_codes) with the word `wiki`. For example, if you want to build an Arabic-English corpus, you should download the relevant files from the `arwiki` dump, since there are fewer Arabic articles than English articles.

Example:

    wget http://dumps.wikimedia.org/arwiki/20140831/arwiki-20140831-page.sql.gz
    wget http://dumps.wikimedia.org/arwiki/20140831/arwiki-20140831-langlinks.sql.gz

#### Extract parallel titles

To extract the parallel corpus run the following where the first command line argument is the ISO 639 code of the target language and the second argument is the (path) prefix of the database dump files.

Example:

    ./build-corpus.sh en arwiki-20140831 > titles.txt

#### Language-specific filtering

If one of the languages in the pair uses a specific Unicode range, you can easily filter out lines that do not contain such characters. Example filters for a few scripts are included in the `filters/` directory.

For example, the following will filter out pairs that do not contain at least one [Perso-Arabic](http://en.wikipedia.org/wiki/Persian_alphabet) character:

    ./build-corpus.sh en arwiki-20140831 | ./filters/filter-perso-arabic.pl > titles.txt

#### Software dependencies

It is recommended that you have the `uconv` tool ([International Components for Unicode](http://site.icu-project.org/)) installed since it is used to normalize Unicode characters.

