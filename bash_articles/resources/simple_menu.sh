#!/bin/bash

get_citation () {
  local citation_indice=$((RANDOM%4))
  case $citation_indice in
    0) echo "Noob, je suis un noob. Un no-life un vrai. Je joue au MMORPG";;
    1) echo "42";;
    2) echo "Si l'école sa rendait les hommes libres et égaux, le gouvernement déciderait que c'est pas bon pour les marmots.";;
    *) echo "Insérer citation ici";;
  esac
}

print_citation () {	
	figlet -v > /dev/null 2> /dev/null && FIGLET_INSTALLED=0 || FIGLET_INSTALLED=1
	fortun -v > /dev/null 2> /dev/null && FORTUNE_INSTALLED=0 || FORTUNE_INSTALLED=1

	if [[ $FORTUNE_INSTALLED -eq 0 ]]
		then CITATION="$(fortune)"
		else CITATION="$(get_citation)"
	fi

	[ $FIGLET_INSTALLED -eq 0 ] && figlet -nt "$CITATION" || echo "$CITATION"
}

menu () {
	local action_choice="1 - Calculer quelque chose ? 
2 - Etre éclairer par la sagesse de tes ancêtres ? 
3 - Epingle Jésus à sa croix ?"
	local question="Bonjour, jeune scarabée. Dieu te parle et te propose de trouver la voie. As-tu besoin de"
	local not_an_option="Désolé, mais je n'ai pas compris le sens profond de ton interrogation ? Veux-tu ?"
	clean=${1:-0}
	[ $clean -eq 0 ] && echo "$question" || echo "$not_an_option"
	echo "$action_choice"
	read -r -n 1 -p "" reponse
	echo
	case $reponse in 
		1) calcul;;
		2) print_citation;;
		3) exit 1;;
		*) return 2;;
	esac
}

calcul () {
	read -r -p 'Entrez votre calcul : ' response
	echo $[$response]
}

while true 
do
	clean=${clean:-0}
	echo
	menu $clean
	clean=$?
	echo
done