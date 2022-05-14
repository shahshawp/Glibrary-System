menu_choice=""
record_file="Records.ldb"
temp_file=/tmp/ldb.$$
touch $temp_file; chmod 644 $temp_file
trap 'rm -f $temp_file' EXIT


get_return(){
printf '\tPress return\n'
read x
return 0
}

get_confirm(){
printf '\tAre you sure?\n'
while true
do
  read x
  case "$x" in
      y|yes|Y|Yes|YES)
      return 0;;
      n|no|N|No|NO)
          printf '\ncancelled\n'
          return 1;;
      *) printf 'Please enter yes or no';;
  esac
done
}

set_menu_choice(){
clear
printf 'Green University Library Management System'
printf '\n'
printf 'Options:-'
printf '\n'
printf '\t1) Add new Books records\n'
printf '\t2) Find Books\n'
printf '\t3) Edit Books\n'
printf '\t4) Remove Books\n'
printf '\t5) View Books\n'
printf '\t6) Add Students\n'
printf '\t7) Find Student\n'
printf '\t8) Quit\n'
printf 'Please enter the choice then press return\n'
read menu_choice
return
}

insert_record(){
echo $* >>$record_file
return
}


add_books(){

printf 'Enter Books category:-'
read tmp
liCatNum=${tmp%%,*}

printf 'Enter Books title:-'
read tmp
liTitleNum=${tmp%%,*}

printf 'Enter Auther Name:-'
read tmp
liAutherNum=${tmp%%,*}

printf 'About to add new entry\n'
printf "$liCatNum\t$liTitleNum\t$liAutherNum\n"

if get_confirm; then
   insert_record $liCatNum,$liTitleNum,$liAutherNum
fi

return
}

find_books(){
  echo "Enter book title to find:"
  read book2find
  grep $book2find $record_file > $temp_file

  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "Found the following"
        cat $temp_file
        get_return
        return 0
  esac
return
}

remove_books() {

  linesfound=`cat $record_file|wc -l`

   case `echo $linesfound` in
   0)    echo "Sorry, nothing found\n"
         get_return
         return 0
         ;;
   *)    echo "Found the following\n"
         cat $record_file ;;
        esac
 printf "Type the books title which you want to delete\n"
 read searchstr

  if [ "$searchstr" = "" ]; then
      return 0
   fi
 grep -v "$searchstr" $record_file > $temp_file
 mv $temp_file $record_file
 printf "Book has been removed\n"
 get_return
return
}

view_books(){
printf "List of books are\n"

cat $record_file
get_return
return
}
add_students(){

printf 'Enter Student Name:-'
read tmp
linameNum=${tmp%%,*}

printf 'Enter Student id:-'
read tmp
liidNum=${tmp%%,*}

printf 'Enter Cell no:-'
read tmp
licellNum=${tmp%%,*}

printf 'About to add new student\n'
printf "$linameNum\t$liidNum\t$licellNum\n"

if get_confirm; then
   insert_record $linameNum,$liidNum,$licellNum
fi

return
}

find_students(){
  echo "Enter Student ID to find:"
  read student2find
  grep $student2find $record_file > $temp_file

  linesfound=`cat $temp_file|wc -l`

  case `echo $linesfound` in
  0)    echo "Sorry, nothing found"
        get_return
        return 0
        ;;
  *)    echo "Found the following"
        cat $temp_file
        get_return
        return 0
  esac
return
}


edit_books(){

printf "list of books are\n"
cat $record_file
printf "Type the tile of book you want to edit\n"
read searchstr
  if [ "$searchstr" = "" ]; then
     return 0
  fi
  grep -v "$searchstr" $record_file > $temp_file
  mv $temp_file $record_file
printf "Enter the new record"
add_books

}

rm -f $temp_file
if [!-f $record_file];then
touch $record_file
fi

clear
printf '\n\n\n'
printf 'Green University Library Management System'
sleep 5

quit="n"
while [ "$quit" != "y" ];
do

set_menu_choice
case "$menu_choice" in
1) add_books;;
2) find_books;;
3) edit_books;;
4) remove_books;;
5) view_books;;
6) add_students;;
7) find_students;;
8) quit=y;;
*) printf "Sorry, choice not recognized";;
esac
done

rm -f $temp_file
echo "Finished"

exit 0