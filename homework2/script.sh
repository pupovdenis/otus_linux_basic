#!/bin/bash

directory=$1

if [ -z "$directory" ]; then
	echo "The directory parameter is empty."
	exit
fi

if [ -d "$directory" ]; then
 	current_dir=$(pwd)

  cd "$directory" || exit

  counter_bak=0
  counter_backup=0
  counter_tmp=0

  for file in .[!.]* *; do
    if [ -f "$file" ]; then
      if [[ $file == *.bak ]]; then
          rm "$file"
          echo "file $file was removed"
          let "counter_bak++"
      fi
      if [[ $file == *.backup ]]; then
          rm "$file"
          echo "file $file was removed"
          let "counter_backup++"
      fi
      if [[ $file == *.tmp ]]; then
          rm "$file"
          echo "file $file was removed"
          let "counter_tmp++"
      fi
    fi
  done

  echo "*****"

  if [[ $counter_bak -gt 0 ]]; then
  	echo "were removed $counter_bak *.bak files"
  else
  	echo "was not find any *.bak files"
  fi

  if [[ $counter_backup -gt 0 ]]; then
  	echo "were removed $counter_backup *.backup files"
  else
  	echo "was not find any *.backup files"
  fi

  if [[ $counter_tmp -gt 0 ]]; then
  	echo "were removed $counter_tmp *.tmp files"
  else
  	echo "was not find any *.tmp files"
  fi

  cd "$current_dir" || exit
else
     	echo "Error. No such directory."
     	exit 2
fi
