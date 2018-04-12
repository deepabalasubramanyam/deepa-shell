#!/bin/bash
#
# This script is based on an analysis of the "math" script from Advanced
# Bash Lesson 1. It represents an improvement in the scripting, based on
# best practices.
#
# Usage: ./adv_exercise2

# Initialize global variables.
NUMBER=0
NUMBER1=0
NUMBER2=0
CORRECT_ANSWER=0
ANSWER=0
CORRECT=0
MAX_TRIES=3

function generate_question()
{
  generate_numbers
  determine_operation
  QUESTION="$NUMBER1 $OPERATION $NUMBER2"
}

function generate_numbers()
{
  generate_number
  NUMBER1=$NUMBER
  generate_number
  NUMBER2=$NUMBER
}

# Generate a random number between 1-10, including the number 10.
function generate_number()
{
  NUMBER=$((RANDOM%10+1))
}

# Choose what needs to be done as an operation.
function determine_operation()
{
  RAND=$((RANDOM%3))
  case $RAND in
    1) OPERATION='*';;
    2) OPERATION='+';;
    3) OPERATION='-';;
  esac
}

function calculate_answer()
{
  CORRECT_ANSWER="$(echo $(($QUESTION)))"
}

function check_answer()
{
  if [ $ANSWER -eq $CORRECT_ANSWER 2>/dev/null ]; then
    echo "Correct!"
    CORRECT=1
    if [ $TRY -ne 1 ]; then
      write_log
    fi
  else
    if [ $TRY -eq $MAX_TRIES ]; then
      TRY=$((MAX_TRIES +1))
      write_log
      echo "The correct answer was $CORRECT_ANSWER"
      echo "Try another one? (yes or no)"
      read "TRYAGAIN"
      TRYAGAIN2=$(echo $TRYAGAIN | /usr/bin/tr [:upper:] [:lower:])
      if [ $TRYAGAIN2 = "no" ]; then
        echo 'Thanks for playing!'
        exit 0
      else
        continue
      fi
    else
      TRY=$(($TRY + 1))
      echo "Nope, sorry. Please try again...(Attempt $TRY)"
    fi
  fi
}

function init_log()
{
  echo "---------- Log for $(date +%d-%m-%Y' '%H:%M)" >> log
}

function write_log()
{
  if [ $TRY -le $MAX_TRIES ]; then
    echo "Answer to $QUESTION ($CORRECT_ANSWER) given in $TRY tries" >> log
  else
    echo "Answer to $QUESTION ($CORRECT_ANSWER) not given" >> log
  fi
}

init_log

while true
do
  CORRECT=0
  TRY=1

  generate_question
  calculate_answer

  echo "How much is $QUESTION ? (Attempt $TRY)"
  #echo "(Correct answer is $CORRECT_ANSWER)"
  while [ $CORRECT -ne 1 ] && [ $TRY -le $MAX_TRIES ]
  do
    read "ANSWER"
    check_answer
  done

done

exit 0
