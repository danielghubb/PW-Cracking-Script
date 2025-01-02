#!/bin/bash

letter=""
pwlength=0
ausgabe=""

#Passwortlänge ermitteln
for i in {1..5000}
do
./crackme "$letter"
result=$?

if [ "$result" -eq "1" ]; then
   echo "Schlüssellänge ist: $(($i-1))";
   pwlength=$(($i-1))
   break
fi

letter="${letter}a"
done

######
#Buchstabenermitteln

for pw in {{a..z},{A..Z},{0..9}};
do

schluessel=""
for j in $( eval echo {1..$pwlength})
do
schluessel="${schluessel}${pw}"
done


timemax=0
timemin=$(($pwlength + 4))

for k in {1..1000}
do

tss=$(date +%s%N)
./crackme "$schluessel"
tse=$(date +%s%N)
timet=$((($tse - $tss)/800000000))


if [ "$timet" -gt "$timemax" ]; then
   timemax=$timet
fi

if [ "$timet" -lt "$timemin" ]; then
   timemin=$timet
fi

differenz=$(($timemax - $timemin))

if [ "$differenz" -eq "4" ]; then

   if [ "$timemin" -lt "$pwlength" ]; then
      anzahl=$(($pwlength - $timemin))

      for l in $( eval echo {1..$anzahl})
      do
      ausgabe="${ausgabe}${pw}"
      done
   fi
   break
fi

done

done

bash crackme2.sh "$ausgabe" "$pwlength"
