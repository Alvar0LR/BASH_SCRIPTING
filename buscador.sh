#!/bin/bash

#variables de colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#function contrl c
function ctrl_c(){
 echo -e "\n\n${redColour}[!]${endColour}${purpleColour} Saliendo del programa...${endColour}\n"
 tput cnorm && exit 1
}

#contrl c
trap ctrl_c INT

#variables globales
main_url=https://htbmachines.github.io/bundle.js
ruta_descarga=$(pwd)
#funciones

function helpPanel(){
 echo -e "\n${yellowColour}[+]${endColour} ${blueColour}Uso${endColour}:"
 echo -e "\n${redColour}u)${endColour} ${blueColour} Descargar o actualizar archivos necesarios${endColour}:"
 echo -e "\t${redColour}m)${endColour} ${blueColour} Buscar por nombre de maquina ${endColour}"
 echo -e "\t${redColour}i)${endColour} ${blueColour} Buscar por direccion IP ${endColour}"
 echo -e "\t${redColour}y)${endColour} ${blueColour} Obtener link de youtube  ${endColour}"
 echo -e "\t${redColour}s)${endColour} ${blueColour} Buscar por Skills  ${endColour}"
 echo -e "\t${redColour}o)${endColour} ${blueColour} Buscar por O.S ${endColour}"
 echo -e "\t${redColour}d)${endColour} ${blueColour} Mostrar maquina por dificultad  ${endColour}"
 echo -e "\t${redColour}h)${endColour} ${blueColour} Mostrar este panel de ayuda ${endColour}"

}

function searchMachine(){
 machineName="$1"
 echo -e "\n ${turqoiseColour}[+] Listando las propiedades de la maquina ${endColour}"
 machineChecker=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//')
 if [ "$machineChecker" ]; then
   echo -e "\n INFO MACHINE: \n $machineChecker"
 else
   echo -e "\n La maquina no existe"
 fi

}

function updateFiles(){

 if [ ! -f bundle.js ]; then
 tput civis
 echo -e "\n ${greenColour} [*] Descargando archivos necesarios...${endColour}"
 curl -s -X GET $main_url > bundle.js
 js-beautify bundle.js | sponge bundle.js
 echo -e "\n ${yellowColour} [*] Todos los archivos han sido descargados${endColour}"
 tput cnorm
 else
 tput civis
 echo -e "\n ${redColour} [*] Actualizando... ${endColour}"
 curl -s -X GET $main_url > bundle_temp.js
 js-beautify bundle_temp.js | sponge bundle_temp.js
 echo -e "\n ${yellowColour} [*] Agregado archivo temporal ${endColour}  \n\n ${greenColour} ruta: $ruta_descarga ${endColour}"
 hash_bundle=$(md5sum bundle.js | awk '{print $1}')
 hash_bundle_temp=$(md5sum bundle_temp.js | awk '{print $1}')
 if [ "$hash_bundle" == "$hash_bundle_temp" ]; then
 echo -e "\n ${purpleColour} [=] Todo al dia ${endColour}"
 rm bundle_temp.js
 else
 echo -e "\n ${purpleColour} [=!] Descargando Actualizaciones${endColour}"
 sleep 1
 rm bundle.js &&  mv bundle_temp.js bundle.js
 echo -e "\n ${greenColour} [o] Actualizaciones completadas...${endColour}"
 fi
 tput cnorm
 fi
}

function searchIP(){
 ipAdress="$1"
 machineName=$(cat bundle.js | grep "ip: \"$ipAdress\"" -B 3 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')
 if [ "$machineName"  ]; then
  echo -e "\n ${yellowColour}[*]${endColour} ${grayColour}La ip:${endColour} ${redColour}$ipAdress${endColour} corresponde con la ${grayColour}maquina${endColour}: ${blueColour}$machineName${endColour}"
 else
  echo "la ip proporcionada no coincide con ninguna maquina"
 fi
}

function getLink(){
 machineName="$1"
 enlaceMaquina=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')
 if [ "$enlaceMaquina" ]; then
 echo -e "\n El enlace de la maquina $machineName es: $enlaceMaquina "
 else
 echo -e "\n La maquina no existe "
 fi
}

function getDificultad(){
 dificultad="$1"
 case "$dificultad" in Fácil|Media|Dificil|Insane)
  echo -e "\n${redColour}[+]${endColour} ${blueColour} Las maquinas con la dificultad $dificultad son: ${endColour}"
  maquinas=$(cat bundle.js | grep "dificultad: \"$dificultad\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)
  echo -e "\n $maquinas"
  ;;
 *)
  echo -e "\n La dificultad seleccionada no existe (Fácil, Media, Dificil, Insane)"
  ;;
 esac

}

function findBySo(){
 so="$1"
 machinecheck=$(cat bundle.js | grep "so: \"$so\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)
 if [ "$machinecheck" ]; then
  echo -e "\n Listando las maquinas por sistema: $so"
  cat bundle.js | grep "so: \"$so\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
 else
  echo -e "\n No existen maquinas por el sistema: $so"
 fi
}

function getOsDificultyMachines(){
 dificulty="$1"
 so="$2"

 echo -e "\n Filtrando maquinas por dificultad: $dificulty y O.S: $so"
 maquinascheck=$(cat bundle.js | grep "so: \"$so\"" -C 4 | grep "dificultad: \"$dificulty\"" -B 5 | grep "name: " | tr -d '"' | tr -d ',' | awk '{print $2}' | column)
 if [ "$maquinascheck" ]; then
  #cat bundle.js | grep "so: \"$so\"" -C 4 | grep "dificultad: \"$dificulty\"" -B 5 | grep "name: " | tr -d '"' | tr -d ',' | awk '{print $2}' | column
  echo -e "\n $maquinascheck"
 else
  echo -e "\n No existen maquinas con esos criterios"
 fi
}

function findBySkill(){
 skill="$1"
 machinechecker=$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)

 if [ "$machinechecker" ]; then
  echo -e "\n $machinechecker"
 else
  echo -e "No se ha encontrado ninguna maquina con este filtro: $skill"
 fi

}

#Indicadores
declare -i parameter_counter=0
#chivatos
declare -i chivato_dificulty=0
declare -i chivato_so=0

while getopts "m:us:o:d:y:i:h" arg; do
 case $arg in
  m) machineName=$OPTARG; let parameter_counter+=1;;
  u) let parameter_counter+=2;;
  i) ipAdress=$OPTARG; let parameter_counter+=3;;
  y) machineName=$OPTARG; let parameter_counter+=4;;
  d) dificultad=$OPTARG; chivato_dificulty=1; let parameter_counter+=5;;
  o) sistema=$OPTARG; chivato_so=1; let parameter_counter+=6;;
  s) skill=$OPTARG; let parameter_counter+=7;;
  h) ;;
 esac
done

if [ $parameter_counter -eq 1 ]; then
   searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
   updateFiles
elif [ $parameter_counter -eq 3 ]; then
   searchIP $ipAdress
elif [ $parameter_counter -eq 4 ]; then
   getLink $machineName
elif [ $parameter_counter -eq 5 ]; then
   getDificultad $dificultad
elif [ $parameter_counter -eq 6 ]; then
   findBySo $sistema
elif [ $chivato_dificulty -eq 1 ] && [ $chivato_so -eq 1 ]; then
   getOsDificultyMachines $dificultad $sistema
elif [ $parameter_counter -eq 7 ]; then
   findBySkill "$skill"
else
   helpPanel
fi