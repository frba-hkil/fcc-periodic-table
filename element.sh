#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1  ORDER BY atomic_number")
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$RESULT" | while IFS='|' read NUMBER NAME SYMBOL TYPE MASS MP BP
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
  fi
  else
    if [[ ${#1} -gt 2 ]]
    then
      SEARCH="name"
    else
      SEARCH="symbol"
    fi
  RESULT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $SEARCH='$1'  ORDER BY atomic_number")
    if [[ -z $RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      echo "$RESULT" | while IFS='|' read NUMBER NAME SYMBOL TYPE MASS MP BP
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
      done
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
