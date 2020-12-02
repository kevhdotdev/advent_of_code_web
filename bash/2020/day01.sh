#!/bin/bash

echo -n "Part One: "
while read x; do
  while read y; do
    echo -e $(($x*$y)):$(($x+$y))
  done < $1
done < $1 | grep 2020$ | head -1 | cut -d : -f 1

echo -n "Part Two: "
while read x; do
  while read y; do
    while read z; do
      echo -e $(($x*$y*$z)):$(($x+$y+$z))
    done < $1
  done < $1
done < $1 | grep 2020$ | head -1 | cut -d : -f 1

