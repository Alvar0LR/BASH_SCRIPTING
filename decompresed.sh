#!/bin/bash

#funciones
function ctrl_c(){
echo -e "\n\n[!] Saliendo...\n"
exit 1
}
#control c
trap ctrl_c INT

#variables
first_file_name="ejer.gz"
decompresed_file_name="$(7z l ejer.gz | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"

7z x $first_file_name &>/dev/null

while [ $decompresed_file_name ]; do
echo "Nuevo archivo descomprimido: $decompresed_file_name"
7z x $decompresed_file_name &>/dev/null
decompresed_file_name="$(7z l $decompresed_file_name 2>/dev/null | tail -n 3 | head -n 1 | awk 'NF{print $NF}')"
done
