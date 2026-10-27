#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

HIGHEST_NUMBER=10
SECRET_NUMBER=$(( $RANDOM % $HIGHEST_NUMBER ))
NUMBER_OF_GUESSES=1

echo "Enter your username:"
read ENTERED_USERNAME

FOUND_USERNAME=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$ENTERED_USERNAME'")

if [[ -z $FOUND_USERNAME ]]
then
  echo "Welcome, $ENTERED_USERNAME! It looks like this is your first time here."
else
  echo $FOUND_USERNAME | while IFS="|" read USERNAME GAMES_PLAYED BEST_GAME
  do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
fi

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

if [[ -z $FOUND_USERNAME ]]
then
  INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$ENTERED_USERNAME', 1, $NUMBER_OF_GUESSES)")
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$ENTERED_USERNAME'")
  BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$ENTERED_USERNAME'")

  (( GAMES_PLAYED += 1 ))
  if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
  then
    UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED, best_game = $NUMBER_OF_GUESSES WHERE username = '$ENTERED_USERNAME'")
  else
    UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username = '$ENTERED_USERNAME'")
  fi
fi
echo You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!