#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

HIGHEST_NUMBER=1000
SECRET_NUMBER=$(( $RANDOM % $HIGHEST_NUMBER ))
NUMBER_OF_GUESSES=0

echo "Enter your username:"
read USERNAME

FOUND_USERNAME=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")



echo "Guess the secret number between 1 and $HIGHEST_NUMBER:"
read ENTERED_NUMBER

while [[ $SECRET_NUMBER -ne $ENTERED_NUMBER ]];
do
  if [[ ! $ENTERED_NUMBER =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
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