wopen -- command line URL opener with autocomplete
==================================================

wopen remembers previously opened URLs and helps quickly open them
with bash autocomplete. wopen also supports URL aliases.

Examples
--------

Open github.com

     $ wopen github.com

Open github.com with autocomplete

     $ wopen gi<TAB>

Open news.ycombinator.com and and saves its URL alias as hn

     $ wopen -a hn news.ycombinator.com

Open news.ycombinator.com with alias

     $ wopen hn

Search only within aliases

     $ wopen .h<TAB>

Installation
------------

Simply source wopen.bash script:

     $ git clone https://github.com/mher/wopen.git
     $ echo "source `pwd`/wopen/wopen.bash" >> .bashrc

Make sure you have installed bash-autocomplete.
