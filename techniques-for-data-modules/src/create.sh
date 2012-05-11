#!/bin/bash

COUNT=$1

rm -rf $COUNT
mkdir $COUNT
cp 88799/*rapper* $COUNT

# Raw data
head -n$COUNT  88799/data.txt > $COUNT/data.txt

# CoffeeScript module
echo "module.exports = [" > $COUNT/data.coffee
sed -e's/\t/\", \"cf\": /g' $COUNT/data.txt  | sed -e 's/^/\  {\"name\": \"/g' | sed -e 's/$/\},/g' >> $COUNT/data.coffee
echo "]" >> $COUNT/data.coffee

# JavaScript module
coffee -c $COUNT/data.coffee

# JSON data
NEXT=`head -n$((COUNT+1)) 88799/data.txt | tail -n1  | cut -f1`
sed -e "s/,{\"name\":\"$NEXT\".*//g" 88799/data.json > $COUNT/data.json
echo "]" >> $COUNT/data.json
