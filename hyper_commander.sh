#!/usr/bin/env bash
# shellcheck disable=SC2162

permissionUpdatedText="Permissions have been updated."

function out_menu() {
  options=(Exit "OS info" "User info" "File and Dir operations" "Find Executables")

  app_name="Hyper Commander"
  pad='                           '
  border="------------------------------"
  echo "$border"
  printf "| %s%s|\n" "$app_name" "${pad:${#app_name}}"

  for (( i = 0; i < ${#options[@]}; i++ ));
  do
   rawLineItem="$i: ${options[i]}"
   printf "| %s%s|\n" "$i: ${options[i]}" "${pad:${#rawLineItem}}"
  done
  echo $border
}

function list_files() {
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

function list_and_process_input() {
  while true

    list_files && read input
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

function rename_file() {
   echo "Enter the new file name: " && read input
   mv "$1" "$input"
   printf "%s has been renamed as %s\n" "$1" "$input"
}

function update_all_read_and_write_permission() {
   chmod a=rw "$1"
   printf "%s\n" "$permissionUpdatedText"
   stat "$1"
}

function update_read_and_write_permission() {
   chmod u=rw "$1"
   chmod g=rw "$1"
   chmod o=r "$1"
   printf "%s\n" "$permissionUpdatedText"
   stat "$1"
}

function manage_file() {

   border="---------------------------------------------------------------------"
   rawLineItem="| 0 Back | 1 Delete | 2 Rename | 3 Make writable | 4 Make read-only |"

   while true
   printf "\n%s\n%s\n%s\n" "$border" "$rawLineItem" "$border"
   read input
   do
     case $input in
      0) break;;
	    1) rm "$1" && printf "%s has been deleted." "$1" && break;;
	    2) rename_file "$1" && break;;
	    3) update_all_read_and_write_permission "$1" && break;;
      4) update_read_and_write_permission "$1" && break;;
      *) echo "Invalid option!";;
     esac
   done
}

function search_executable() {

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
  $1 "$input"
}

function main() {
    printf "Hello %s!\n" "$USER"
    while true

    out_menu && read input
    do
       case $input in
        0) echo -e "Farewell!" && break ;;
    	  1) printf "%s\n" "$(uname -on)";;
    	  2) printf "%s\n" "$(whoami)";;
    	  3) list_and_process_input;;
        4) search_executable;;
        *) echo "Invalid option!" ;;
       esac
    done
}

main