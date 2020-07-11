#! /usr/bin/bash
# this function used to print(for example : Pinging 'java' for user 'root')
function pinging()
{
if [ $flagForGrep == 1 ] && [ $flagForUser == 1 ];then
	echo "Pinging '$ggrep' for user '$user' "
elif [ $flagForGrep == 1 ] && [ $flagForUser == 0 ];then
	echo "Pinging '$ggrep' for user any user "
elif [ $flagForGrep == 0 ] && [ $flagForUser == 0 ];then
	echo "Pinging for any .exe for user any user "
elif [ $flagForGrep == 0 ] && [ $flagForUser == 1 ];then
	echo "Pinging for any .exe for user '$user' "
fi
}
# this function used to print(for example : java : 2 instance (s))
function PrintToTerminal()
{
if [ $flagForGrep == 1 ];then
	echo "$ggrep : $splitNumFromString instance (s)"
else 
	echo "$splitNumFromString instance (s)"
fi
}
#main
u=0 # for top command
d=0 # for top command
n=0 # for top command
timeOut=1 #defulat 1 second.
limit=-1 #infinite
stringToTop=""
flagForGrep=0
flagForUser=0
if [ "$#" != 0 ];then
for args in "$@"; do # for loop for all the arguements
if [ $args == "-u" ];then
	u=$(( u+1 ))
	flagForUser=1
elif [ $u == 1 ];then
	user=$args
	u=0	
	stringToTop=$stringToTop" -u "$args
elif [ $args == "-t" ]; then #t
	d=$(( d+1 ))
elif [ $d == 1 ];then
	timeOut=$args
	d=0
elif [ $args == "-c" ]; then #c
	n=$(( n+1 ))
elif [ $n == 1 ];then
	limit=$args
	n=0
elif [ $u == 0 ] && [ $d == 0 ] && [ $n == 0 ];then
	ggrep=$args
	flagForGrep=1
fi
done
num=0
pinging 
while true ;do
if [ $flagForGrep == 0 ] ; then
top -n 1 $stringToTop > outout.txt
else 
top -n 1 $stringToTop | grep $ggrep > outout.txt
fi
line=$(wc -l outout.txt) #returns numbers of lines(intop outout.txt) to line
splitNumFromString=$(echo $line | tr -dc '0-9')
if [ $splitNumFromString -ne "0" ];then
	PrintToTerminal
fi
num=$(( num+1 ))
if [ $num == $limit ] ; then 
break 
fi
sleep $timeOut
done 
# else of  if statment line 12
else 
echo "no arguments"
fi
