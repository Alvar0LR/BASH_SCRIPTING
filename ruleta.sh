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
