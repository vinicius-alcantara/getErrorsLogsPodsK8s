#!/bin/bash

######## VAR's ########
WORK_DIR_SCRIPT_MAIL="/home/vinicius.alcantara/GET-ERRORS-K8S-CLUSTER";
cd "$WORK_DIR_SCRIPT_MAIL";
CURRENT_LOCAL="$(pwd)";
#source getErrorLog.sh;
SMTP_SRV="smtp.office365.com";
SMTP_PORT="587";
SMTP_USR="$(echo -ne 'xxxxxx' | base64 -d)";
SMTP_PASS="$(echo -ne 'xxxxxxx' | base64 -d)";
MAIL_FROM="$(echo -ne 'yyyyyyyy' | base64 -d)";
MAIL_TO="$(echo -ne "yyyyyyyyy" | base64 -d)";
SUBJECT="REPORT: PODs com status diferente de Running";

HEADER_REPORT_FILE="
From: "$MAIL_FROM"
To: "$MAIL_TO"
Subject: "$SUBJECT"
#Content-Type: text/html; charset="utf8"

`echo "
Segue a Lista de pods com status diferente de Running no Cluster K8s:
#####################################################################################
"`
";

function createHeaderReportFile(){
    echo "$HEADER_REPORT_FILE" | sed 1d >> "$CURRENT_LOCAL"/report.txt;
}

createHeaderReportFile;

function sendMailNotification(){
        cd "$CURRENT_LOCAL";
        curl --ssl-reqd \
          --url "$SMTP_SRV":"$SMTP_PORT" \
          --user "$SMTP_USR":"$SMTP_PASS" \
          --mail-from "$MAIL_FROM" \
          --mail-rcpt "$MAIL_TO" \
          --upload-file "$CURRENT_LOCAL"/report.txt

}

#sendMailNotification;

