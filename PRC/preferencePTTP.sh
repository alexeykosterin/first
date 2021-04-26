#!/bin/sh

DIR=`pwd`
FILE=dump.txt

if [ -f $DIR/preference.txt ]; then
rm -f $DIR/preference.txt
fi;

if [ -f $DIR/weight.txt ]; then
rm -f $DIR/weight.txt
fi;

HEAVY=~/hrs_102/conf/brt/user_specific/brt/properties.cfg
intersection=intersection.txt
intersection2=intersection2.txt
number=number.txt

min=`cat $HEAVY | sed -n '/preference_tariffication_redefinition/=' | head -1`
max=`cat $HEAVY | sed -n '/preference_tariffication_redefinition/=' | tail -1`

sed -n ''$min','$max'p' $HEAVY > $intersection
cat $intersection | grep "is_intersection = " > $intersection2

min2=`cat $intersection2 | grep -v "//" | sed -n '/is_intersection /=' | head -1`
max2=`cat $intersection2 | grep -v "//" | sed -n '/is_intersection /=' | tail -1`

#выбирает номер строки MAX
head -n $max2 $intersection2 | tail -n 1 > $number
NUMB=`cat $number | cut -d '{' -f1 | sed s/[^0-9]//g`

for F in `cat $DIR/$FILE`; do

#добавляет +1 к максимальному весу
let "NUMB += 1"
echo "NUMB = $NUMB"

PTTP=`cat $DIR/$FILE | grep $F | cut -d ';' -f1`
NAME=`cat $DIR/$FILE | grep $F | cut -d ';' -f2`
PACK=`cat $DIR/$FILE | grep $F | cut -d ';' -f3`
echo "is_intersection = "$NUMB" { parameter=2 {jg_a_subscriber   { jg_vec_pack_id; }  } const = "$PACK"; }" >> weight.txt
echo "//$NAME" >> preference.txt
echo "definition {" >> preference.txt
echo "result = "\"$PTTP\"";" >> preference.txt
echo "condition {" >> preference.txt
echo  "is_intersection { parameter = 2 {jg_a_subscriber  { jg_vec_pack_id; } } const = "$PACK";}" >> preference.txt
echo "}" >> preference.txt
echo "}" >> preference.txt
done

rm -f $intersection
rm -f $intersection2
rm -f $number