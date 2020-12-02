#!/bin/bash

echo -n "Part One: "
tr '-' ' ' < $1 | tr -d ':' |
while read min max chr password; do
  count=`echo $password | tr -cd $chr | wc -c`
  if (( min <= count && max >= count )); then echo 1; fi
done | wc -l

echo -n "Part Two: "
tr '-' ' ' < $1 | tr -d ':' |
while read min max chr password; do
  one=${password:(( min - 1 )):1}
  two=${password:(( max - 1 )):1}
  if [ $one == $chr ]; then if [ $two != $chr ]; then echo 1; fi fi
  if [ $two == $chr ]; then if [ $one != $chr ]; then echo 1; fi fi
done | wc -l
