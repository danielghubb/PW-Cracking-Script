#!/bin/bash

eingabe=$1
pwlength=$2
cor_key=""

echo "$eingabe"
echo "$pwlength"

#schlüssel aus erstem ermitteltem Buchstaben
schluesselpw=""
pw=${eingabe:0:1}
for j in $( eval echo {1..$pwlength})
do
schluesselpw="${schluesselpw}${pw}"
done

#minimalwert für ersten Schlüssel ermitteln
minvalue=$pwlength
timemaxs=0
timemins=$(($pwlength + 4))

for m in {1..1000}
do

tss=$(date +%s%N)
./crackme "$schluesselpw"
tse=$(date +%s%N)
timet=$((($tse - $tss)/800000000))


if [ "$timet" -gt "$timemaxs" ]; then
   timemaxs=$timet
fi

if [ "$timet" -lt "$timemins" ]; then
   timemins=$timet
fi

differenzs=$(($timemaxs - $timemins))

if [ "$differenzs" -eq "4" ]; then
    minvalue=$timemins
    break
fi

done




#restliche Reihenfolge bestimmen

for i in $( eval echo {1..$(($pwlength-1))})
do
exchange=${eingabe:$i:1}

	for l in $( eval echo {0..$(($pwlength-1))})
	do
	final="${schluesselpw:0:l}$exchange${schluesselpw:l+1:pwlength-l}"
	timemax=0
	timemin=$(($pwlength+4-1))


		for k in {1..1000}
		do

		tss=$(date +%s%N)
		./crackme "$final"
		tse=$(date +%s%N)
		timet=$((($tse - $tss)/800000000))
		echo "Time: $timet"

		if [ "$timet" -gt "$timemax" ]; then
		timemax=$timet
		fi

		if [ "$timet" -lt "$timemin" ]; then
   		timemin=$timet
		fi

		differenz=$(($timemax - $timemin))

		if [ "$differenz" -eq "4" ]; then

   		if [ "$timemin" -lt "$minvalue" ]; then
			minvalue=$timemin
			schluesselpw=$final


		 if [ "$timemin" -eq "0" ]; then
                     echo "Das Passwort lautet: $final"
                     ./crackme "$final"
                     exit 1
                fi  

			break
   		fi
   		break
		fi

		done

	done

done






