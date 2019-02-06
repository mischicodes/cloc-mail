# cloc-mail
Runs cloc against a specified git repo and uses SMTP auth to mail results to specified email recipient

Usage:
./cloc-mail.sh $scantarget $resultsemail

ex: ./cloc-mail.sh https://github.com/myliang/x-spreadsheet michael.linder@gmail.com

Configuration:
The script uses an organizational SMTP server to send the scan results of git URL $scantarget to email $resultsemail.
The outgoing organizational SMTP server hostname must be set as variable SMTPSERVER near the top of the script.


