#!/bin/bash

COUNT=$1

rm -rf $COUNT
mkdir $COUNT
cp template/*rapper* $COUNT

# Raw data
head -n$COUNT  template/data.txt > $COUNT/data.txt

# JSON data
NEXT=`head -n$((COUNT+1)) template/data.txt | tail -n1  | cut -f1`
sed -e "s/,{\"name\":\"$NEXT\".*//g" template/data.json > $COUNT/data.json
echo "]" >> $COUNT/data.json


# CoffeeScript module
echo "module.exports = [" > $COUNT/data.coffee
sed -e's/\t/\", \"cf\": /g' $COUNT/data.txt  | sed -e 's/^/\  {\"name\": \"/g' | sed -e 's/$/\},/g' >> $COUNT/data.coffee
echo "]" >> $COUNT/data.coffee
# And minimised
CONTENT=`sed -e's/\t/\",f:/g' $COUNT/data.txt  | sed -e 's/^/\{n:\"/g' | sed -e 's/$/\}/g' | tr '\n' ','`
echo "module.exports=[$CONTENT]"  > $COUNT/data-min.coffee
# As json
JSON=`cat $COUNT/data.json`
echo "module.exports=JSON.parse '$JSON'" >> $COUNT/data-json.coffee


# JavaScript module
coffee -c $COUNT/data.coffee
# And minimised
#coffee -c $COUNT/data-min.coffee
cp $COUNT/data-min.coffee $COUNT/data-min.js
# As json
JSON=`cat $COUNT/data.json`
echo "module.exports=JSON.parse('$JSON');" >> $COUNT/data-json.js
