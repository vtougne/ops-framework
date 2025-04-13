#!/bin/bash

in_file=$1

IFS="
"
previous_line_number=0

for line in `grep -n johny $in_file | sed "s/^\([0-9]*\): *\([^ ]*\).* \(.*\)$/\1 \2 \3/g"` ; do
  line_number=`echo $line | awk {'print $1'}`

  
  
  

  # echo "debug previous_line_number: $previous_line_number"
  if [[ ! $previous_line_number == 0 ]] ; then
    ((second_line_numer=previous_line_number + 1))
	((before_previous_line_number=line_number - 1))

    echo "sedcmd: sed -n '${second_line_numer},${before_previous_line_number}p' $in_file"
    # echo $first_line>$file_name
    # eval "cat $in_file | sed -n '${second_line_numer},${before_previous_line_number}p'" >> $file_name
  fi
  first_line=`echo $line | awk {'print $3'}`
  file_name=`echo $line | awk {'print $2'}`
  folder=${file_name%/*}
  # folder=${folder/\\/\/}
  echo "debug folder: $folder"
  echo "debug line_number: $line_number file_name : $file_name 		 first_line : $first_line folder: $folder"
  # [ ! -d $folder ] && mkdir $folder
  previous_line_number=$line_number
  
done
