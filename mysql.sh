#!/bin/bash

userid=$(id -u)
timestamp=$(date -%F+%H+%M+%S)
scriptname=$(echo $0 | cut -d "." -f1)
logfile=/tmp/$scriptname-$timestamp.log
R="\e[31m"
G="\e[32m"
N="\e[0m"


validate(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$2 .. $G Success $N"
    else
        echo -e "$2 .. $R Failure $N"
        exit 1
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
mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$logfile

