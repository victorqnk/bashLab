#!/bin/bash

show_help() {
  echo "Usage: ./countlines.sh [-o <owner>] [-m <month>]"
}

count_lines() {
  local owner=$1
  local month=$2

  if [ -n "$owner" ]; then
    files=$(find . -maxdepth 1 -type f -name "*.txt" -user "$owner")
  elif [ -n "$month" ]; then
    files=$(find . -maxdepth 1 -type f -name "*.txt" -newermt "$(date -d "$month 1" +"%Y-%m-01")" ! -newermt "$(date -d "$month 1 +1 month -1 day" +"%Y-%m-%d")")
  fi

  if [ -n "$owner" ]; then
    echo "Looking for files where the owner is: $owner"
  elif [ -n "$month" ]; then
    echo "Looking for files where the month is: $month"
  fi

  # count the lines of vailable files
  for file in $files; do
    lines=$(grep -c '' "$file")
    echo "File: $file, Lines: $lines"
  done
}

# if no arguments are provided
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

while getopts ":o:m:" opt; do
  case $opt in
    o)
      owner=$OPTARG
      ;;
    m)
      month=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      show_help
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      show_help
      exit 1
      ;;
  esac
done

count_lines "$owner" "$month"
