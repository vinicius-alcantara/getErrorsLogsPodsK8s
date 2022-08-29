#!/bin/bash

#### VARs ####
source sendmail.sh;

function countPodsNotRunning(){
	cd "$WORK_DIR_SCRIPT_MAIL";
	QTD_PODS=$(kubectl get po --all-namespaces | egrep -v "Running" | egrep -v "Completed" | sed 1d | wc -l);
	echo "Quantidade de pods listados: $QTD_PODS" >> report.txt;
	echo "#####################################################################################" >> report.txt;
	echo " " >> report.txt;
}

countPodsNotRunning;

for NAMESPACE in $(kubectl get po --all-namespaces | egrep -v "Running" | egrep -v "Completed" | sed 1d | cut -d " " -f1 | uniq);
do
	if [ -n "$NAMESPACE" ];
	then
        echo "## Aplication Namespace: $NAMESPACE" >> report.txt
        for POD_NAME in $(kubectl get po -n $NAMESPACE | egrep -v "Running" | egrep -v "Completed" | sed 1d | cut -d " " -f1 | sed ':a; N; $!ba; s/\n/,/g');
        do
    		if [ -n "$POD_NAME" ];
		then
			POD_NAME=$(echo "$POD_NAME" | tr ',' ' ');
			declare -i QTD_PODS_NAME=$(echo "$POD_NAME" | wc -w);
				for ((i=$QTD_PODS_NAME; i != 0; i--));
				do
					POD_NAME_FINAL=$(echo $POD_NAME | cut -d " " -f $i);
					echo "## Pod Name: $POD_NAME_FINAL" >> report.txt;			
					kubectl describe po "$POD_NAME_FINAL" -n "$NAMESPACE" | egrep -i "Reason:" >> report.txt;
					kubectl describe po "$POD_NAME_FINAL" -n "$NAMESPACE" | egrep -A 10 "Events:" >> report.txt;
 					echo "#####################################################################################" >> report.txt;
				done
		fi
        done
	fi
done

sendMailNotification;

exit 0;
