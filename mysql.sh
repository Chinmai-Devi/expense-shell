#!/bin/bash

userid=$(id -u)

if [ $userid -eq 0 ]
    then 
    echo "you have admin access so proceeding further"
else
    echo "pls run with admin access"
    exit 1
fi