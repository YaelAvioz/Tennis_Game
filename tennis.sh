#!/bin/bash

P1=0
P2=1
POINTS=(50 50)
BETS=(0 0)
BALL_OFFSET=0

function printBoard() {
  echo " Player 1: ${POINTS[P1]}         Player 2: ${POINTS[P2]} "
  echo " --------------------------------- "
  echo " |       |       #       |       | "
  echo " |       |       #       |       | "

  case ${BALL_OFFSET} in
  3)
    echo " |       |       #       |       |O"
    ;;
  2)
    echo " |       |       #       |   O   | "
    ;;
  1)
    echo " |       |       #   O   |       | "
    ;;
  0)
    echo " |       |       O       |       | "
    ;;
  -1)
    echo " |       |   O   #       |       | "
    ;;
  -2)
    echo " |   O   |       #       |       | "
    ;;
  -3)
    echo "O|       |       #       |       | "
    ;;
  esac

  echo " |       |       #       |       | "
  echo " |       |       #       |       | "
  echo " --------------------------------- "
}

# Get a bet for a player from the console
function betInput() {
  while true; do
    read -rsp "PLAYER $((${1} + 1)) PICK A NUMBER: " BETS["${1}"] && echo
    if [[ "${BETS[${1}]}" =~ ^[0-9]+$ ]] && [[ BETS[${1}] -le POINTS[${1}] ]]; then
      POINTS[${1}]=$((POINTS[${1}] - BETS[${1}]))
      break
    fi
    echo "NOT A VALID MOVE !"
  done
}

# Move ball towards a given player
function moveBall() {
  if [[ $1 -eq P1 ]]; then
    if [[ BALL_OFFSET -lt 0 ]]; then
      BALL_OFFSET=$((BALL_OFFSET - 1))
    else
      BALL_OFFSET=-1
    fi
  else
    if [[ BALL_OFFSET -gt 0 ]]; then
      BALL_OFFSET=$((BALL_OFFSET + 1))
    else
      BALL_OFFSET=1
    fi
  fi
}

printBoard

while true; do
  betInput P1
  betInput P2

  # if p1 won the bet
  if [[ BETS[P1] -gt BETS[P2] ]]; then
    moveBall P2

  # elif p2 won the bet
  elif [[ BETS[P2] -gt BETS[P1] ]]; then
    moveBall P1

  fi

  printBoard
  echo -e "       Player 1 played: ${BETS[P1]}\n       Player 2 played: ${BETS[P2]}\n\n"

  # If the ball is at 3, player 1 wins
  if [[ BALL_OFFSET -eq 3 ]]; then
    echo "PLAYER 1 WINS !"
    break
  fi

  # If the ball is at -3, player 2 wins
  if [[ BALL_OFFSET -eq -3 ]]; then
    echo "PLAYER 2 WINS !"
    break
  fi

  # If both players reached 0
  if [[ POINTS[P1] -eq 0 ]] && [[ POINTS[P2] -eq 0 ]]; then

    # If he ball is on P2's side
    if [[ BALL_OFFSET -gt 0 ]]; then
      echo "PLAYER 1 WINS !"
      break
    elif [[ BALL_OFFSET -lt 0 ]]; then
      echo "PLAYER 2 WINS !"
      break
    else
      echo "IT'S A DRAW !"
      break
    fi

  # if only P1 reached 0
  elif [[ POINTS[P1] -eq 0 ]]; then
    echo "PLAYER 2 WINS !"
    break

  # if only P2 reached 0
  elif [[ POINTS[P2] -eq 0 ]]; then
    echo "PLAYER 1 WINS !"
    break

  fi
done
