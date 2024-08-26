#!/usr/bin/zsh

# This just checks that you don't have uncommited work.  If you have uncommited work. then
# you really don't want to be running this script.
#
if [[ -n $( git status -s ) ]]
then
   print "error: you have uncommitted work"
   print "       refusing to run"
   exit
fi >&2

# This shell script should fail if any (unguarded) command fails.
#
set -e

# This function is executed on exit, including if something fails.  It might be helpful to
# know which branch you end up in.
#
TRAPEXIT ()
{
   print -l "" "check which branch you've ended up in:"
   git branch | sed 's/^/  /'
}

# Show what we're executing, then execute it.
#
execute ()
{
   print -- '  $' $argv
   $argv
}

execute git checkout --quiet master

execute test -f cat.txt
execute test -f dog.txt
execute test -f mouse.txt

# Check that there are only three files.
#
print -l * | wc -l | execute grep -q -w 3

print -l "master branch is correct" ""

# The "no-dog" branch is the same as master, except the file "dog.txt" has been removed."
#
# The master branch must be an ancestor of the no-dog branch.  This means that you must first
# create your master branch, and then create your no-dog branch from that.  You cannot start
# from scratch.
#
execute git checkout --quiet no-dog
execute git merge-base --is-ancestor master no-dog

execute test -f cat.txt
execute test -f mouse.txt

# Check that there are only two files.
#
print -l * | wc -l | execute grep -q -w 2

print -l "no-dog branch is correct" ""

# The "cats" branch is the same as master, except that there are more cats.
#
# The master branch must be an ancestor of the cats branch.  This means that you must first
# create your master branch, and then create your cats branch from that.  You cannot start
# from scratch.
#
# The no-dog branch *must not* be an ancestor of the cats branch.
#
# (In other words, go back to "master" and create "cats" from there.)
#
execute git checkout --quiet cats
execute git merge-base --is-ancestor master cats

if execute git merge-base --is-ancestor no-dog cats
then
   print "error (no-dog should not be an ancestor of cats)!"
   false  # Force failure.
fi

beasts=( cat dog mouse lion tiger siamese )
for beast in $beasts
do
   execute test -f $beast.txt
done

# Check that there are exactly six files.
#
print -l * | wc -l | execute grep -q -w 6

print -l "cats branch is correct" ""

# The "zoo" branch is the same as "cats", except that all of the beasts have
# been moved to a directory called zoo.
#
# Use "git mv ..." to move files (do not just remove the files and create the new ones).
#
# This will be checked manually.
#
# The cats branch must be an ancestor of the zoo branch.  This means that you must first
# create your cats branch, and then create your zoo branch from that.  You cannot start
# from scratch.
#
execute git checkout --quiet zoo
execute git merge-base --is-ancestor cats zoo

for beast in $beasts
do
   execute test -f zoo/$beast.txt
done

# Check that there is only one directory.
#
print -l * | wc -l | execute grep -q -w 1
execute test -d zoo

# Check that there are six beasts in the zoo.
#
print -l zoo/* | wc -l | execute grep -q -w 6

print -l "zoo branch is correct" ""

execute git checkout --quiet master
TRAPEXIT () {}  # We don't need this any more.
