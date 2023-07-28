#!/usr/bin/env bash

options=(Exit "OS info" "User info" "File and Dir operations" "Find Executables")

appName="Hyper Commander"
permissionUpdatedText="Permissions have been updated."
length=${#options[@]}
min=0

function outMenu() {
  pad='                           '
  border="------------------------------"
  echo "$border"
  printf "| %s%s|\n" "$appName" "${pad:${#appName}}"
  
  for (( i = min; i < length; i++ ));
  do
   rawLineItem="$i: ${options[i]}"
   printf "| %s%s|\n" "$i: ${options[i]}" "${pad:${#rawLineItem}}"
  done
  echo $border
}

function listFiles() {
  title="The list of files and directories:"
  printf "\n%s\n" "$title"
  border="---------------------------------------------------"
  rawLineItem="| 0 Main menu | 'up' To parent | 'name' To select |"
  files=(*)
  for file in "${files[@]}"
  do
    if [[ -f "$file" ]]; then
       printf "F %s\n" "$file"
    elif [[ -d "$file" ]]; then
       printf "D %s\n" "$file"
    fi
  done
 
  printf "\n%s\n%s\n%s\n" "$border" "$rawLineItem" "$border"
  
}

function listAndProcessInput() {
  while true

    listFiles && read input
  do

    if [[ "$input" != 0 ]]; then
       if [[ -d "$input" ]]; then
          cd "$input" || exit
       elif [[ "$input" == "up" ]]; then
          cd ..
       elif [[ -f "$input" ]]; then
          manageFile "$input"
       else
	  echo "Invalid input!"
       fi
    else break
    fi

  done
}

function renameFile() {
   echo "Enter the new file name: " && read input
   mv "$1" "$input"
   printf "%s has been renamed as %s\n" "$1" "$input"
}

function updateAllReadAndWritePermission() {
   chmod a=rw "$1"
   printf "%s\n" "$permissionUpdatedText"
   stat "$1"
}

function updateReadAndWritePermission() {
   chmod u=rw "$1"
   chmod g=rw "$1"
   chmod o=r "$1"
   printf "%s\n" "$permissionUpdatedText"
   stat "$1"
}

function manageFile() {
   
   border="---------------------------------------------------------------------"
   rawLineItem="| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"
   
   while true
   printf "\n%s\n%s\n%s\n" "$border" "$rawLineItem" "$border"
   read input
   do
     case $input in
        0) break;;
	    1) rm "$1" && printf "%s has been deleted." "$1" && break;;
	    2) renameFile "$1" && break;;
	    3) updateAllReadAndWritePermission "$1" && break;;
        4) updateReadAndWritePermission "$1" && break;;
        *) echo "Invalid option!";;
     esac
   done
}

function searchExecutable() {

   echo "Enter an executable name: " && read input
   
   location=$(which "$input")
   
   if [[ "$location" == *"$input"* ]]; then
      printf "Located in: %s\n" "$location"
      execute "$input"
   else
     printf "The executable with that name does not exist!\n"
   fi
}

function execute() {
  
  echo "Enter arguments: " && read input
  $1 $input
}

printf "Hello %s!\n" "$USER"
while true

outMenu && read input
do

   case $input in
    0) echo -e "Farewell!" && break ;;
	1) uname -on;;
	2) whoami;;
	3) listAndProcessInput;;
    4) searchExecutable;;
    *) echo "Invalid option!" ;;
   esac
done