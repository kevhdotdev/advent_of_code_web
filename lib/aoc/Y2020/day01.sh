#!/bin/bash

echo -n "Part One: "
while read x; do
  while read y; do
    echo -e $(($x*$y)):$(($x+$y))
  done < priv/inputs/2020/01.txt
done < priv/inputs/2020/01.txt | grep 2020$ | head -1 | cut -d : -f 1

echo -n "Part Two: "
while read x; do
  while read y; do
    while read z; do
      echo -e $(($x*$y*$z)):$(($x+$y+$z))
    done < priv/inputs/2020/01.txt
  done < priv/inputs/2020/01.txt
done < priv/inputs/2020/01.txt | grep 2020$ | head -1 | cut -d : -f 1

