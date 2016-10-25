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
	if [ -z $1 ]
	then
		read -r -p 'Entrez votre calcul : ' response
		echo $[$response]
	else
		echo $[$1]
	fi
}

# Two flags implémentation
# Text Variables
GET_OPT=`getopt -o hsvc: --long help,surprise-me,version,calculate: -n 'Simple Menu Supinfo Bash article using 2 flags' -- "$@"`
VERSION="Simple Menu using Getopt version: 0.0.1"
HELP_MESSAGE="Usage: simple_menu_getopt.sh [OPTIONS]

Simple menu script used to present bash and getop in a school article.
This script require getopt to run correctly. (Install gnu-getopt to run from mac).
By default, process in interactive. Running it with -c or -s option make it non interactive.

Options:

-c, --calculate     Run a calcul with the provided argument (ex: -c \"1+2\")
-h, --help          Print this message
-s, --surprise-me   Surprise
-v, --version       Print soft version

"
# Exec variable
c=1; s=1; interactive=0;
eval set -- "$GET_OPT"
while true
do
	case "${1}" in
		-h|--help)
			echo "$HELP_MESSAGE"; exit 0;;
		-v|--version)
			echo "$VERSION"; exit 0;;
		-c|--calculate)
			c=0; expression=$2; interactive=1; shift 2;;
		-s|--surprise-me)
			s=0; interactive=1; shift 1;;
		--) shift; break;;
		*) echo "Options ${1} is not a known option."; echo "$HELP_MESSAGE" exit 1;;
	esac
done

# Proceding 
if [ $interactive -eq 0 ]
then
	while true 
	do
		clean=${clean:-0}
		echo
		menu $clean
		clean=$?
		echo
	done
else
	[ $c -eq 0 ] && calcul $expression
	[ $s -eq 0 ] && print_citation
fi