#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guessing_game -t --no-align -c"

SECRET_NUMBER=$(( $RANDOM % 10 ))
NUMBER_OF_GUESSES=0
read ENTERED_NUMBER

while [[ $SECRET_NUMBER -ne $ENTERED_NUMBER ]];
do
  if [[ ! $ENTERED_NUMBER = ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again"
  else
    if [[ $SECRET_NUMBER -lt $ENTERED_NUMBER ]]
    then
      echo "It's lower than that, guess again:"
    else
      echo "It's higher than that, guess again:"
    fi

    (( NUMBER_OF_GUESSES += 1 ))
  fi

  read ENTERED_NUMBER
done

echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!