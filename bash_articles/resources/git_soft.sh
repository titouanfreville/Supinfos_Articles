#!/bin/bash
###########################################################################
############################## FUNY GIT SOFT ##############################
###########################################################################
## Small bash script to help managing multiple git repository store in a ##
## unique known folder (ex : ~/git).																		 ##
###########################################################################
## AUTHOR : Titouan FREVILLE <titouanfreville@gmail.com> 								 ##
###########################################################################
# -------------------- VARIABLES ------------------------------------------
# ### STYLES ### #
bold="\e[1;"
thin="\e[0;"
# ### COLORS ### #
green="32m"
red="31m"
blue="34m"
basic="\\033[0;39m"
# ### ### #
# ### VERSIONS ### #
TOOL_VERSION="Git Soft : 0.0.1"
# ### ### #
# ### GIT CLONE ROOTS ### #
GIT_CLONE_ROOT_SSH="git@github.com:"
GIT_CLONE_ROOT_HTTP="github.com/"
# ### ### #
# ### HTTP S VARS ### #
HTTP="http://"
HTTPS="https://"
# ### ### #
# ### HELP MESSAGES ### #
# GENERAL -------------------
# ---------------------------
GENERAL_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] COMMAND [COMMAND_OPTIONS] [ARGUMENTS]

Small git soft program to help managing git repo.

WARNINGS:

* On Mac OS, you have to download gnu-getopt so this soft can work.
* The process block by default push on master branch.
  It does not ensure push safety for other branches. You have to configure it by yourself.


Options:

-c, --config  Print current configuration if nor arguments provided.
							If arguments provided, update configuration to add the provided config.
							Configurations :
							* branch safety : to add a branch as locked, use -c ADD_LOCK=BRANCH_NAME
							* base branch to look : to add a base branch for repositories,
								use -c ADD_BASE=\"FOLDER_PATERN=BRANCH_NAME\"
-h, --help 		Print this message
-v, --version Print tool version


Commands:

check_install   Check that git is correctly installed. If git it is not, try to install it. This command require admin rights.
check_ssh 		  Check if git can be used with ssh clones.
ssh_init 			  Help you to configure git to add ssh support.
clone 					Clone provided git url at root of the default git folder.
update 					Go in all git repositorie in default git folder and update them using provided base branch (default is master).
commit   			  Search for all modification to commit on known files by default (commit -a).
push    				Push all commited modifications.
"
# ---------------------------
# CHECK INSTALL -------------
CHECK_INSTALL_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] check_install [COMMAND_OPTIONS]

Check Install function :

Check your that your git installation is ready. If not, install it.

Options:

-h, --help 		Print this message.
-i, --init 		Init your git to use ssh if not setted.
-s, --ssh     Also check for git ssh corectness.
"
# ---------------------------
# CHECK SSH -----------------
CHECK_SSH_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] check_ssh [COMMAND_OPTIONS]

Check SSH function :

Check your that your git installation can use SSH.

Options:

-h, --help 		 Print this message.
-i, --init 		 Init your git to use ssh if not setted.
"
# ---------------------------
# SSH INIT ------------------
SSH_INIT_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] ssh_init [COMMAND_OPTIONS] MAIL_ADDRESS

Ssh Init function :

Initialise your git installation to use ssh using provided email.

Options:

-d, --detached  Run the process as non interactive.
-h, --help 		  Print this message.
-n, --name 	 		Name for the ssh-key (Used in non interactive mode, default is id_github)
"
# ---------------------------
# CLONE ---------------------
CLONE_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] check_install [COMMAND_OPTIONS] REPO_PATHS/CLONE_URLS ...

Clone function :

Clone git repository passed in arguments using ssh if setted, https else. You can force one mode
by using the -f option. If you use -f, you have to pass the full clone url
(git@github.com:XXXX ou https://github.com/XXXX). If you do not pass the -f tag, please pass only
the path of the repository (Creator/Repository_Name or Organisation/Repository_Name).

Options:

-f, --force   Force clone type using full url.
-h, --help 		Print this message
"
# ---------------------------
# UPDATE --------------------
UPDATE_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] update [COMMAND_OPTIONS]

Update function :

Go through all the git repositories to update git repositories.

Options:

-b, --branch 	Add prioritary base branch informations. (-b REPOSITORY_NAME:BRANCH_TO_CHECK)
-h, --help 		Print this message.
-l, --locked  Add locked branch for specific repository. (-l REPOSITORY_NAME:BRANCH_TO_LOCK)
"
# ---------------------------
# COMMIT KNOWN --------------
COMMIT_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] commit [COMMAND_OPTIONS]

Commit function :

Go through all the git repositories to commit. By default, it commit only known files (commit -a).

Options:

-a, --all
-h, --help 		Print this message.
-m 						Use message for repo. (-m REPO:MESSAGE)
"
# ---------------------------
# PUSH ----------------------
PUSH_HELP_MESSAGE="Usage : ./git_soft.sh [OPTIONS] push [COMMAND_OPTIONS]

Push function :

Go through all the git repositories to push.

Options:

-h, --help 		Print this message.
-l, --locked  Add locked branch for specific repository. (-l REPOSITORY_NAME:BRANCH_TO_LOCK)
"
# ---------------------------
# ### ### #
# -------------------------------------------------------------------------
# -------------------- Functionalities ------------------------------------
# ### GIT INSTALLED ### #
check_install_func () {
	echo -e "$thin$bule Checking if git is correctly installed $basic"
	git --version > /dev/null 2> /dev/null
	if [ $? -eq 0 ]
	then
		echo -e "$bold$green Git est bien installé $basic"
	else
		sudo apt-get install -qy git || echo -e "bold$red Git is not installed $basic"
	fi
}
# ### ### #
# ### SSH ENABLED ### #
check_ssh_func () {
	echo -e "$thin$bule Checking if git is setted up to support ssh $basic"
	ssh -T git@github.com > /dev/null 2> /dev/null
	if [ $? -eq 0]
	then
		echo -e "$bold$green Git is ready to use ssh clone. $basic"
		return 0
	else
		echo -e "$bold$red Git is not correctly setted to support ssh. $basic"
		return 1
	fi
}
# ### ### #
# ### INIT SSH ### #
init_ssh_func () {
	echo -e "$thin$blue Initializing git to use ssh $basic"
	local email=$1
	local interactive=${2:-0}
	local key_name=${3:-id_github}
	if [ $interactive -eq 0 ]
	then
		ssh-keygen -t rsa -b 4096 -C $email
	else
		echo -e "$thin$blue Generating ssh key using : $email as mail comment, $HOME/$key_name as path for the new file and without password"
		ssh-keygen -t rsa -b 4096 -C $email -f $HOME/$key_name -q -N "" && echo -e "$bold$green Key generated in $HOME/$key_name" || { echo -e "$bold$red Failed to generate key"; exit 1; }
	fi
	eval "$(ssh-agent -s)" > /dev/null 2> /dev/null
	ssh-add $HOME/$key_name && echo -e "$bold$green Key correctly generated and usable. $basic" || { echo -e "$bold$red Failed to add Key to user Agent. Not ready. $basic"; exit 1; }
	xclip -sel clip < $HOME/$key_name.pub > /dev/null 2> /dev/null && echo -e "$thin$green Public key copied to clipboard. $basic" || echo -e "$thin$red Failed to use xclip. $basic"
	echo -e "$bold$blue Tried to paste the copied key to git (if you don't see key, it mean that it failed). If failed, copy the following lines to github. $basic"
	echo -e "$thin$blue >>> Public key start $basic"
	cat $HOME/$key_name.pub
	echo "$thin$blue >>> Public key end $basic"
}
# ### ### #
# ### CLONE ### #
multi_way_cloning () {
	local clone_path=$1
	git clone $GIT_CLONE_ROOT_SSH$clone_path > /dev/null 2> /dev/null \
	&& echo -e "$clone_path well cloned using SSH$basic" \
	|| { git clone $HTTPS$GIT_CLONE_ROOT_HTTP$clone_path 1> /dev/null \
	&& echo -e "$bold$green $clone_path well cloned using HTTP$basic" \
	|| echo -e "$bold$red Error why cloning $clone_path. Can't clone with either HTTP or SSH. $basic"; }
}

clone_func () {
	echo -e "$thin$blue Start cloning $basic"
	local forced=1
	local clone_path=""
	case "$1" in
		0) forced=0;;
		*) forced=1;;
	esac
	shift
	cd $GIT_HOME
	if [ $forced -eq 0 ]
	then
		for arg in $@
		do
			echo -e ">>>$thin$blue Cloning $arg $basic"
			git clone "$arg" 1> /dev/null && echo -e "$bold$green $arg well cloned$basic" || echo -e "$bold$red Error while cloning : $arg$basic"
		done
	else
		for arg in $@
		do
			echo -e ">>>$thin$blue Cloning $arg $basic"
			case "$arg" in
				http://github.com/*)
					clone_path=${arg##http://github.com/}
					multi_way_cloning "$clone_path"
					;;
				https://github.com/*)
					clone_path=${arg##https://github.com/}
					multi_way_cloning "$clone_path"
					;;
				git@github.com:*)
					clone_path=${arg##git@github.com:}
					multi_way_cloning "$clone_path"
					;;
				*/*) multi_way_cloning "$arg"
				*) echo -e "$bold$red $arg is not well formated. Please provide a repo path (User/Repo or Organisation/Repo) or the clone url. $basic"
			esac
		done
	fi
}
# ### ### #
# ### UPDATE  ### #
update_action_func () {
	local checkout_branch=$1
	local base_branch=$(git branch | grep \* | cut -d ' ' -f2)
	local checkout=0
	if [[ "${LOCKED_BRANCHES[@]}" == *"${base_branch}"* ]]
	then
		echo -e "$bold$red Only Gods are allowed to break locked branches. You are not god. $basic"
		git pull
		return 666
	fi
	if [[ $checkout_branch == $base_branch ]]
		then checkout=1
	fi
	[ $checkout -eq 0 ] && git stash
	[ $checkout -eq 0 ] && git checkout $checkout_branch
	[ $checkout -eq 0 ] && git checkout $base_branch
	[ $checkout -eq 0 ] && git merge $checkout_branch
	[ $checkout -eq 0 ] && git push
	[ $checkout -eq 0 ] && git stash apply
	[ $checkout -eq 0 ] && git stash drop stash@{0}
}

update_check_specific () {
	for el in ${!SPECIFIC_BRANCH_CHECK[@]}
	do
		if [[ $1 == *"$el"* ]]
		then
			update_action_func ${SPECIFIC_BRANCH_CHECK[$el]}
			return  0
		fi
	done
	return 1
}

update_check_repo () {
	for repo in $1/*
	do
		if [[ -d ${repo} ]]
		then
			if [[ -d ".git" ]]
			then
				update_check_specific $repo
				if [ $? -ne 0 ]
				then
				else
					update_action_func 'master'
				fi
			fi
			update_check_repo ${repo}
		fi
	done
}
# ### COMMIT ### #
commit_action_func () {
	local message
	local commit="git commit -a"
	local base_branch=$(git branch | grep \* | cut -d ' ' -f2)

	if [ $# -gt 2 ]
	then
		message=$1
		commit="git commit"
	else
		case "$1" in
			0) commit="git commit";;
			*) message="$1";;
		esac
	fi

	if [[ "${LOCKED_BRANCHES[@]}" == *"${base_branch}"* ]]
	then
		echo -e "$bold$red Only Gods are allowed to break locked branches. You are not god. $basic"
		return 666
	fi

	if [ -z $message ]
	then
		$commit
	else
		$commit "$message"
	fi
}

commit_check_specific () {
	for el in ${!COMMIT_MESSAGE_TABLE[@]}
	do
		if [[ $1 == *"$el"* ]]
		then
			commit_action_func ${COMMIT_MESSAGE_TABLE[$el]} $2
			return  0
		fi
	done
	return 1
}

commit_check_repo () {
	for repo in $1/*
	do
		if [[ -d ${repo} ]]
		then
			if [[ -d ".git" ]]
			then
				commit_check_specific $repo $1
				if [ $? -ne 0 ]
				then
				else
					commit_action_func $1
				fi
			fi
			commit_check_repo ${repo} $1
		fi
	done
}
# ### PUSH ### #
push_func () {
	for repo in $1/*
	do
		if [[ -d ${repo} ]]
		then
			if [[ -d ".git" ]]
			then
				cd ${repo} && git push
			fi
			commit_check_repo ${repo} $1
		fi
	done
}
# ### ### #
# -------------------------------------------------------------------------
# -------------------- Commands Functions ---------------------------------
# ### CHECK INSTALL ### #
check_install () {
	local get_opt=`getopt -o his -l help,init,ssh -n 'Funny git script Check Install' -- "$@"`
	local init=1
	local ssh=1
	eval set -- "$get_opt"
	while true
	do
		case "$1" in
			-h|--help)
				echo "$CHECK_INSTALL_HELP_MESSAGE"; exit 0;;
			-s|--ssh)
				ssh=0; shift 1;;
			-i|--init)
				init=0; shift 1;;
			--) shift; break;;
			*) echo "Options ${1} is not a known option."; echo "$CHECK_INSTALL_HELP_MESSAGE"; exit 1;;
		esac
	done
	check_install_func
	[ $ssh -eq 0 ] && check_ssh_func
	[ $init -eq 0 ] && { check_ssh_func || init_ssh_func ; }
}
# ### ### #
# ### CHECK SSH ### #
check_ssh () {
	local get_opt=`getopt -o hi -l help,init-n 'Funny git script Check Check SSH' -- "$@"`
	local init=1
	eval set -- "$get_opt"
	while true
	do
		case "$1" in
			-h|--help)
				echo "$CHECK_SSH_HELP_MESSAGE"; exit 0;;
			-i|--init)
				init=0; shift 1;;
			--) shift; break;;
			*) echo "Options ${1} is not a known option."; echo "$CHECK_SSH_HELP_MESSAGE"; exit 1;;
		esac
	done
	check_install_func
	[ $init -eq 0 ] && { check_ssh_func || init_ssh_func ; } || check_ssh_func
}
# ### ### #
# ### SSH INIT ### #
ssh_init () {
	local get_opt=`getopt -o dhn: -l detached,help,name: -n 'Funny git script Init SSH' -- "$@"`
	local name
	local interactive=0
	eval set -- "$get_opt"
	while true
	do
		case "$1" in
			-h|--help)
				echo "$SSH_INIT_HELP_MESSAGE"; exit 0;;
			-d|--detached)
				interactive=1; shift 1;;
			-n|--name)
				name=$2; shift 2;;
			--) shift; break;;
			*) echo "Options ${1} is not a known option."; echo "$SSH_INIT_HELP_MESSAGE"; exit 1;;
		esac
	done
	init_ssh_func $1 $interactive $name
}
# ### ### #
# ### CLONE ### #
clone () {
	local get_opt=`getopt -o fh -l forced,help -n 'Funny git script Clone' -- "$@"`
	local name
	local forced=1
	eval set -- "$get_opt"
	while true
	do
		case "$1" in
			-h|--help)
				echo "$CLONE_HELP_MESSAGE"; exit 0;;
			-f|--forced)
				detached=0; shift 1;;
			--) shift; break;;
			*) echo "Options ${1} is not a known option."; echo "$CLONE_HELP_MESSAGE"; exit 1;;
		esac
	done

	clone_func
}
# ### ### #
