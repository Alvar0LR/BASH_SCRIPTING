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

#funcion de salir
function ctrl_c(){
  echo -e "\n\n [!] Saliendo...\n"
  exit 1
}

#Ctrl+C
trap ctrl_c INT

#funciones
function helpPanel(){
 echo -e "\t${yellowColour}[+]${endColour} ${blueColour}Uso${endColour}:"
 echo -e "\t${redColour}m)${endColour} ${blueColour} Dinero con el que se desea jugar ${endColour}"
 echo -e "\t${redColour}t)${endColour} ${blueColour} Tecnica a utilizar  ${endColour}"
}


function martingala(){
  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e " ${greenColour}[+]${endColour} ${grayColour}Dinero actual:${endColour} ${yellowColour}$money€${endColour}"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  echo -e "\n ${greenColour}[+]${endColour} ${grayColour}¿Cuánto dinero tienes pensado apostar?${endColour} -> " && read initial_bet
  echo -e " ${greenColour}[+]${endColour} ${grayColour}¿A qué deseas apostar continuamente (par/impar)?${endColour} -> " && read par_impar

  echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo -e " ${greenColour}[+]${endColour} ${grayColour}Comenzamos con:${endColour} ${yellowColour}$initial_bet€${endColour}"
  echo -e " ${greenColour}[+]${endColour} ${grayColour}Apuesta continua a:${endColour} ${blueColour}$par_impar${endColour}"
  echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  back_bet=$initial_bet
  play_counter=1
  jugadas_malas="[ "

  while true; do
    money=$(($money-$initial_bet))
    echo -e "\n ${purpleColour}[#]${endColour} ${grayColour}Apuestas:${endColour} ${yellowColour}$initial_bet€${endColour}  ${grayColour}| Dinero restante:${endColour} ${yellowColour}$money€${endColour}"

    random_number="$(($RANDOM%37))"
    echo -e "${turquoiseColour}[#]${endColour} ${grayColour}Número salido:${endColour} ${redColour}$random_number${endColour}"

    if [ ! $money -le 0 ]; then
     if [ "$par_impar" == "par" ]; then
        #parte par
       if [ "$(($random_number % 2))" -eq 0 ]; then
         if [ "$random_number" -eq 0 ]; then
           echo -e " ${redColour}[X]${endColour} ${grayColour}Ha salido 0 → pierdes${endColour}"
         else
           echo -e " ${greenColour}[✓]${endColour} ${grayColour}El número es par → ¡GANAS!${endColour}"
           reward=$(($initial_bet*2))
           echo -e " ${greenColour}[+]${endColour} ${grayColour}Ganancia:${endColour} ${yellowColour}$reward€${endColour}"
           money=$(($money+$reward))
           echo -e " ${blueColour}[=]${endColour} ${grayColour}Saldo actual:${endColour} ${yellowColour}$money€${endColour}"
           initial_bet=$back_bet
           jugadas_malas=""
         fi
       else
         echo -e " ${redColour}[X]${endColour} ${grayColour}El número es impar → pierdes${endColour}"
         initial_bet=$(($initial_bet*2))
         jugadas_malas+="$random_number "
         echo -e " ${greenColour}[!]${endColour} ${grayColour}Ahora mismo te quedas en:${endColour} ${yellowColour}$money€${endColour}"
       fi
       echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
       sleep 2
     else
      #parte impar
      if [ "$(($random_number % 2))" -eq 1 ]; then
        echo -e " ${greenColour}[✓]${endColour} ${grayColour}El número es impar → ¡GANAS!${endColour}"
        reward=$(($initial_bet*2))
        echo -e " ${greenColour}[+]${endColour} ${grayColour}Ganancia:${endColour} ${yellowColour}$reward€${endColour}"
        money=$(($money+$reward))
        echo -e " ${blueColour}[=]${endColour} ${grayColour}Saldo actual:${endColour} ${yellowColour}$money€${endColour}"
        initial_bet=$back_bet
        jugadas_malas=""
      else
       if [ "$random_number" -eq 0 ]; then
         echo -e "${redColour}[X]${endColour} ${grayColour}Ha salido 0 → pierdes ${endColour} "
       else
         echo -e "${redColour}[X]${endColour} ${grayColour}El numero es par  → pierdes ${endColour} "
       fi
        initial_bet=$(($initial_bet*2))
        jugadas_malas+="$random_number "
        echo -e " ${greenColour}[!]${endColour} ${grayColour}Ahora mismo te quedas en:${endColour} ${yellowColour}$money€${endColour}"
      fi
       echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
       sleep 2
     fi
    else
       echo -e "${redColour}  [X]${endColour} ${grayColour}Te has quedado a 0 cabroncete${endColour}"
       echo -e "${greenColour}[#]${endColour} ${grayColour}Han habido un total de${endColour} ${yellowColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"
       echo -e "${blueColour} [!]${endColour} ${grayColour}Las malas jugadas han sido: ${endColour}"
       echo -e "${yellowColour}$jugadas_malas${endColour}"
       exit 0
    fi

    let play_counter+=1
       echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  done
}



function inverse(){
 echo -e "\n------------------------------------------------------"
 echo -e "[+] Dinero actual: $money€"
 echo -e "\n------------------------------------------------------"
 echo -e "\n [+] ¿A que deseas apostar continuamente (par/impar)? -> " && read par_impar
 jugadas_malas="[ "
 play_counter=0

 #Secuencia inicial
 declare -a my_sequence=(1 2 3 4)
 my_sequence=("${my_sequence[@]}")
 echo -e "\n [+] Comenzamos con la secuencia ${my_sequence[@]}"

 while true; do
  if [ ${#my_sequence[@]} -eq 0 ]; then
    echo -e "\n [!] el array esta vacio"
    exit 0
  fi

   #Calcular apuesta = primer ultimo
   first=${my_sequence[0]}
   last_index=$((${#my_sequence[@]}-1))
   last=${my_sequence[$last_index]}
   bet=$(($first+$last))

   #Comprobar saldo
   if [ $money -lt $bet ]; then
     echo -e "\n [X] No tienes suficiente dinero para apostar $bet€"
     exit 0
   fi
   # Restar la apuesta del saldo
   money=$(($money-$bet))
   echo -e "\n------------------------------"
   echo -e "[+] Apostando ${yellowColour}$bet€${endColour}"
   echo -e "[+] Secuencia actual: ${my_sequence[@]}"
   echo -e "[+] Saldo tras apostar: ${yellowColour}$money${endColour}"

   random_number=$(($RANDOM % 37))
   echo -e "[+] Ha salido el numero: ${redColour}$random_number${endColour}"

   won=0
   if [ "$par_impar" == "par" ]; then
     if [ "$(($random_number % 2 ))" -eq 0 ]; then
       won=1
     fi
   elif [ "$par_impar" == "impar" ]; then
      if [ "$(($random_number % 2))" -eq 1 ]; then
       won=1
      fi
   else
    echo -e "\n opcion invalida"
    break
   fi

  if [ $won -eq 1 ]; then
    echo -e "${greenColour}[✔] ¡GANAS! ${endColour}"
    reward=$(($bet*2))
    money=$(($money+$reward))
    my_sequence+=($bet)
    echo -e "[+] Nueva secuencia: ${my_sequence[@]}"
    echo -e "[+] Saldo tras premio: ${yellowColour}$money€${endColour}"
  else
    echo -e "${redColour} [X] Has perdido ${endColour}"
    unset my_sequence[0]
    unset my_sequence[$last_index]
    my_sequence=("${my_sequence[@]}")
    echo -e "[+] Secuencia tras perdida: ${my_sequence[@]}"
    jugadas_malas+="$random_number "
  fi

  if [ ${#my_sequence[@]} -eq 0 ]; then
    echo -e "\n ${greenColour}[✔] Has completado la secuencia${endColour}"
    break
  fi

  if [ $money -le 0 ]; then
    echo -e "\n ${redColour}[X] Te has quedado sin dinero${endColour}"
    break
  fi

  echo -e "Lista de malas jugadas $jugadas_malas ]"
  sleep 2

 done


}

while getopts "m:t:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) ;;
  esac
done

if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
     martingala
  elif [ "$technique" == "inverse" ]; then
     inverse
  else
     echo -e "\n La tecnica no existe"
  fi
else
   helpPanel
fi