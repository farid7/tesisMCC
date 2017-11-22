#! /bin/bash

idFile=$1
textFile=$2
port=$3
output=$4
init=$5
fin=$6

re='^[0-9]+$'                  #encontrando id validos

declare -a modules=(1 2 3 4 5 12 13 14 16 17 19 20)  #selected questions
#declare -a modules=(1 2 3 4 5  6 7 8 9 10 11 12 13 14 15 16 17 18 19 20)  #all questions

simiarity() {
			for i in $(seq $init $fin); do
				#echo $i
				id=$(head -$i $idFile | tail -1 | cut -d ',' -f1)
				score=$(head -$i $idFile | tail -1 | cut -d ',' -f2)
				ans=$(cat $textFile | grep -w $id )

				if ! [[ $id =~ $re ]] ; then
					#echo 'id no valido'
					continue
				fi

				echo $id',' > /tmp/$id
				echo $score >> /tmp/$id
				echo "," >> /tmp/$id
				echo $ans | tr -d '[:punct:]' | tr -d '[:digit:]'>> /tmp/$id
				echo "," >> /tmp/$id

				for j in ${modules[@]}; do
					j=$(($j + 1))           #fitting question number
					#echo $j
					temp=$( echo $ans | cut -d ',' -f$j | tr -d '[:digit:]' | tr -d '[:punct:]' | tr '\n' ' ' )

					s_tecno=$( http 0.0.0.0:$port/similarity/tecnologia/"{$temp}") 
					s_necesidad=$( http 0.0.0.0:$port/similarity/necesidad/"{$temp}") 
					s_negocio=$( http 0.0.0.0:$port/similarity/negocio/"{$temp}")
					#s_tecno=999
					#s_necesidad=555
					#s_negocio=111

					# echo $temp
					#echo ","
					 echo $s_tecno >> /tmp/$id
					echo "," >> /tmp/$id
					 echo $s_necesidad >> /tmp/$id
					echo "," >> /tmp/$id
					 echo $s_negocio >> /tmp/$id
					echo "," >> /tmp/$id
						
				done
				echo $(cat /tmp/$id) >> $output

				#echo $id
				#echo $(echo $ans | cut -d ',' -f1)
			done

			#echo "inicia:" $init " termina: " $fin
}
#similarityFlask

echo "id,score,ans,p1Tech,p1Need,p1Bussines,p3Tech,p3Need,p3Bussines,p4Tech,p4Need,p4Bussines,p5Tech,p5Need,p5Bussines,p6Tech,p6Need,p6Bussines,p13Tech,p13Need,p13Bussines,p14Tech,p14Need,p14Bussines,p15Tech,p15Need,p15Bussines,p17Tech,p17Need,p17Bussines,p18Tech,p18Need,p18Bussines,p20Tech,p20Need,p20Bussines,p21Tech,p21Need,p21Bussines," > $output
simiarity 


:'I executed this in this way...
./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 5000 transformed1.csv 1 1278 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 5010 transformed2.csv 1279 2556 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 5050 transformed3.csv  2557 3834 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 6060 transformed4.csv  3835 5112 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 7070 transformed5.csv  5113 6390 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 8080 transformed6.csv  6391 7668 &

./partes_trasforma.sh ids_rankingCategorical.csv coma_stopWord_noImages_data.csv 9090 transformed7.csv  7669 8984 &
'
