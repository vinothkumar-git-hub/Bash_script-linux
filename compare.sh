#!/bin/bash

cd /home/labadmin/script/learning

src="olam.csv"
dest="linux.csv"
outfile="/home/labadmin/script/learning/Lab2020_$(date '+%Y_%m_%d-%H_%M').csv"

while IFS= read -r line;
do
      if ! grep -q "$line" "$src";
      then
          echo "$line"  >> "$outfile"
      fi
done < "$dest"
