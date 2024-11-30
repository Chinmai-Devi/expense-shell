#!/bin/bash

userid=$(id -u)
timestamp=$(date +%F-%H-%M-%S)
scriptname=$(echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-$timestamp.log
R="\e[31m"
G="\e[32m"
N="\e[0m"

echo "pls enter DB password"
read -s mysql_root_password 

validate(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 .. $R Failure $N"
        exit 1
    else
        echo -e "$2 .. $G Success $N"
    fi
}

if [ $userid -eq 0 ]
    then 
    echo "you have admin access so proceeding further"
else
    echo "pls run with admin access"
    exit 1
fi

dnf install mysql-server -y &>>$logfile
validate $? "MySQL Server installation is"
systemctl enable mysqld &>>$logfile
validate $? "enabling MySQL Server"
systemctl start mysqld &>>$logfile
validate $? "Starting MySQL Server is"


#below is the code for non idempotancy 
# <mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile
# validate $? "Setting some root password">

#below command will be usefull for idempotent nature

mysql -h chinmai.cloud -uroot -p${mysql_root_password} -e 'show databases;' &>>$logfile
if [ $? -ne 0 ]
then
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$logfile
    validate $? "Setting some root password"
else
    echo -e "Root swd is already set up so \e[33m skipping $N"
fi




