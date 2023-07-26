#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "TRUNCATE teams,games")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    echo $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS

    #Get winner team id from teams table
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'" )

    #If winner not present in teams table
    if [[ -z $WINNER_ID ]]
    then

      #Insert winner in teams table
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

    fi
    
    #If Insert successfull 
    if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
    then
      echo "Team Data Inserted Successfully."

      #Get winner team id
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'" )
    fi
    

    #-------------------------------------------#

    #Get opponent team id from teams table
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'" )

    #If opponent not present in teams table
    if [[ -z $OPPONENT_ID ]]
    then

      #Insert opponent in teams table
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    fi
    
    #If Insert successfull 
    if [[ $INSERT_OPPONENT_RESULT == "INSERT 0 1" ]]
    then
      echo "Team Data Inserted Successfully."

      #Get opponent team id
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'" )
    fi

   
    #Insert game data
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND','$WINNER_ID','$OPPONENT_ID','$WINNER_GOALS','$OPPONENT_GOALS')")

    #Check Insert game dta result
    if [[ $INSERT_GAME_RESULT = 'INSERT 0 1' ]]
    then
      echo "Inserted Game Data Successfully"
    fi

  fi
done
