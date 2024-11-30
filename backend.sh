#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default node js"

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing Node js"

if expense [ $? -ne 0 ]
then  
    useradd expense &>>$LOGFILE
    VALIDATE $? "creating expense user"
else
    echo -e "user already existed .. $Y skipping $N"
fi


mkdir -p /app  # -p is used for mkdir, if directory is not there then it will create otherwise it will silent and not throw error
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip
VALIDATE $? "downloading backend code"

cd /app
unzip /tmp/backend.zip
VALIDATE $? "Unzipping thw downloaded code"

npm install
VALIDATE $? "installing node js dependencies"





