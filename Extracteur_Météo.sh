#!/bin/bash
#-----------------------------------------------------------------------------------
#INISIALISATION

cd /mnt/c/Users/vayss/downloads/

# Obtenir la date actuelle 
date_actuelle=$(date +"%Y-%m-%d")

# Obtenir l'heure actuelle
heure_actuelle=$(date +"%H:%M:%S")

#-----------------------------------------------------------------------------------
#OPTION PAR DEFAULT

if [ $# -eq 0 ]; then
    arg1="Foix"
else 
    arg1="$1"
fi

#-----------------------------------------------------------------------------------
#RECUPERATION

# Récupérer le contenu wttr.in et le stocker dans recup.html
curl -o recup.html https://wttr.in/$arg1

#-----------------------------------------------------------------------------------
#GESTION ERREUR DE CONNEXION

if [ $? -ne 0 ]; then
    echo "$date_actuelle - $heure_actuelle - Erreur de connexion à wttr.in" >> meteo_error.log
	exit 1
else
    echo "Votre demande de Temperature donne :"
fi

#-----------------------------------------------------------------------------------
#MISE EN FORME

# Nettoyer les séquences de couleurs (ANSI) dans recup.html qui empeche la bonne lecture de nos données et nous empeche de les récupérer
sed -i 's/\x1b\[[0-9;]*m//g' recup.html

#-----------------------------------------------------------------------------------
#TEMPERATURE ACTUELLE

# Recup la température depuis recup.html et ne la recup qu'une fois 
temp_actuel=$(grep -oP '\d+ °C' recup.html | head -n 1)

# Afficher la température
echo -e "\e[31mTempérature actuelle : $temp_actuel\e[0m"

#-----------------------------------------------------------------------------------
#AUTRES INFOS ACTUEL

# Recup la vitesse du vent, l'humidité, la visibilité depuis recup.html et ne les recup qu'une fois 
vitesse_vent_actuel=$(grep -oP '\d+ km/h' recup.html | head -n 1)
humidite_actuel=$(grep -oP '\d+%' recup.html | head -n 1)
visibilite_actuel=$(grep -oP '\d+ km ' recup.html | head -n 1)

# Afficher les infos
echo -e "\e[31mVitesse vent : $vitesse_vent_actuel\e[0m"
echo -e "\e[31mHumidite : $humidite_actuel\e[0m"
echo -e "\e[31mVisibilité : $visibilite_actuel\e[0m"

#-----------------------------------------------------------------------------------
#TEMPERATURE DU LENDEMAIN

# Extraire toutes les températures de la journée et les ranger dans tab_temp, On extrait uniquement les chiffres pour les calculs
mapfile -t tab_temp < <(grep -oP '[+-]?\d+(?:\(\d+\))? °C' recup.html)

# Afficher les temperatures du lendemain 
echo "Températures du lendemain : Matin :${tab_temp[5]}, Midi : ${tab_temp[6]}, Aprem : ${tab_temp[7]}, Soir : ${tab_temp[8]}"

# Formatage
for i in 5 6 7 8; do
  tab_temp[i]=$(echo "${tab_temp[i]}" | grep -oP '\d+' | head -n 1)
done
#imprime la valeur de tab_temp[i], ce qui permet à grep de lire cette valeur depuis l'entrée standard (STDIN).

#afficher sans celsius et infos superflue
echo "Températures du lendemain formater : Matin :${tab_temp[5]}, Midi : ${tab_temp[6]}, Aprem : ${tab_temp[7]}, Soir : ${tab_temp[8]}"

# Calculer la moyenne des températures à l'index 5, 6, 7 et 8 car la temperature de la journée manquant on fait la moyenne des differents moments de la journée
moy_temp=$(( (tab_temp[5] + tab_temp[6] + tab_temp[7] + tab_temp[8]) / 4 ))

# Afficher la température moyenne 
echo -e "\e[31mTempérature (moyenne) de la journée du lendemain : $moy_temp °C\e[0m"

#-----------------------------------------------------------------------------------
#FORMATER SUITE

# Formatage (ajout de celsius)
temp_lendemain="${moy_temp}°C"

#-----------------------------------------------------------------------------------
#REDIRIGER DANS .txt

# Rediriger la commande dans le fichier meteo.txt
echo -e "\e[31m$date_actuelle - $heure_actuelle - $arg1 : $temp_actuel - $temp_lendemain\e[0m" > meteo.txt

# Afficher le contenu du fichier pour vérifier
cat meteo.txt

#-----------------------------------------------------------------------------------
#GESTION HISTORIQUE

fichier_meteo="meteo_$(date +'%Y-%m-%d').txt"

if [ ! -e "$fichier_meteo" ]; then
    touch "$fichier_meteo"
fi

echo -e "$date_actuelle - $heure_actuelle - $arg1 : $temp_actuel - $temp_lendemain" >> "$fichier_meteo"

#-----------------------------------------------------------------------------------
#GESTION HISTORIQUE

echo "{
  \"date\": \"$date_actuelle\",
  \"heure\": \"$heure_actuelle\",
  \"ville\": \"$arg1\",
  \"temperature\": \"$temp_actuel\",
  \"prevision\": \"$temp_lendemain\",
  \"vent\": \"$vitesse_vent_actuel\",
  \"humidite\": \"$humidite_actuel\",
  \"visibilite\": \"$visibilite_actuel\"
}" > meteo_format_JSON.JSON

#-----------------------------------------------------------------------------------
