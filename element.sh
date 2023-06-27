 #!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

INPUT=$1

GET_INFO() {
  # check if input is atomic number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    # get name and symbol from database using given atomic number
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
  # check if input is atomic symbol
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    SYMBOL=$1
    # get atomic number and name from database using given symbol
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$SYMBOL'")
    NAME=$($PSQL "SELECT name FROM elements WHERE symbol = '$SYMBOL'")
  # check if input is the element name
  elif [[ $1 =~ ^[A-Za-z]{3,}$ ]]
  then
    NAME=$1
    # get atomic number and symbol from database using given element name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$NAME'")
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name = '$NAME'")
  fi

  # check if input element is in the database
  if [[ -z $ATOMIC_NUMBER || -z $NAME || -z $SYMBOL ]] 
  then 
    echo "I could not find that element in the database."
  # return information about input element
  else
    TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
}

# check if user gave input and call function, ask for input if not
if [[ $INPUT ]]
then
  GET_INFO $INPUT
else
 echo Please provide an element as an argument.
fi