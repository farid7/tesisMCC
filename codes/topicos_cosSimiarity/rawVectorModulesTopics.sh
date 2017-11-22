#! /bin/bash

#iniciando archivo de salida
#echo "id,score,p1Tech,p1Need,p1Bussines,p3Tech,p3Need,p3Bussines,p4Tech,p4Need,p4Bussines,p5Tech,p5Need,p5Bussines,p6Tech,p6Need,p6Bussines,p13Tech,p13Need,p13Bussines,p14Tech,p14Need,p14Bussines,p15Tech,p15Need,p15Bussines,p17Tech,p17Need,p17Bussines,p18Tech,p18Need,p18Bussines,p20Tech,p20Need,p20Bussines,p21Tech,p21Need,p21Bussines," > salida3topics.csv


#paralelizando ciclo for, para extraer características
tot=$(cat coma_stopWord_noImages_data.csv | wc -l)
n=$(($tot / 4))

id=$1
re='^[0-9]+$'                  #encontrando id validos

#input data
ans=$(cat coma_stopWord_noImages_data.csv | grep -w $id )
rnk=$(cat id_ranking.csv | grep -w $id )

: '
#modules from user form
declare -a m1=(1)
declare -a m2=(2 3 4 5)
declare -a m3=(12)
declare -a m4=(13 14)
declare -a m5=(16 17)
declare -a m6=(19)
declare -a m7=(20)
#for i in ${m2[@]}; do
#	echo $i
#done
'

declare -a modules=(1 2 3 4 5 12 13 14 16 17 19 20)

#chacking valid id
if ! [[ $id =~ $re ]] ; then
echo 'id no valido'
#continue
fi

score=$(echo $rnk | cut -d ',' -f2)

echo $id',' > /tmp/$id
echo $score >> /tmp/$id
echo "," >> /tmp/$id

for i in ${modules[@]}; do
	i=$(($i + 1))           #fitting question number
	temp=$( echo $ans | cut -d ',' -f$i | tr -d '[:digit:]' | tr -d '[:punct:]' | tr '\n' ' ' )

	s_tecno=$( http 148.205.36.110:6060/similarity/tecnologia/"{$temp}") 
	s_necesidad=$( http 148.205.36.110:6060/similarity/necesidad/"{$temp}") 
	s_negocio=$( http 148.205.36.110:6060/similarity/negocio/"{$temp}")
	 
	# echo $temp
	#echo ","
	 echo $s_tecno >> /tmp/$id
	echo "," >> /tmp/$id
	 echo $s_necesidad >> /tmp/$id
	echo "," >> /tmp/$id
	 echo $s_negocio >> /tmp/$id
	echo "," >> /tmp/$id
		
done

echo $(cat /tmp/$id) >> salida3topics.csv

