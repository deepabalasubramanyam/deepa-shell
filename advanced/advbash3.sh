#!/bin/bash
#
# This script is the product of analyzing the "tcsh-conditions" script and
# rewriting it in Bash.
#
# Usage: ./adv_exercise3

# File: conditions.sh

[ -f ./conditions.sh ] && echo "File exists."

# Prompt and then read from the keyboard.
echo "Enter a letter: "
read "VAR1"

if [[ $VAR1 == 'a' ]]; then
  echo '"a" selected.'
else
  echo '"a" not selected.'
fi

# Prompt for a string and read it in.
echo "Enter a string: "
read "VAR2"

# Check if it is "hello" or has "bye" at the end.
case $VAR2 in
  [hH][eE][lL][lL][oO])
    echo "Hello found."
    ;;
  *[bB][yY][eE])
    echo "Bye found."
    ;;
  *)
    echo "Nothing found."
    ;;
esac

# Prompt for a number and read it in.
echo "Enter a number: "
read "VAR3"

# Print the range that the number appears in.
if [[ $VAR3 -ge 1 && $VAR3 -le 9 ]]; then
  echo "1 to 9"
elif [[ $VAR3 -ge 10 && $VAR3 -le 19 ]]; then
  echo "10 to 19"
elif [[ $VAR3 -gt 19 || $VAR3 -eq 0 ]]; then
  echo "Greater than 19 or equal to 0"
else
  echo "Other range"
fi

