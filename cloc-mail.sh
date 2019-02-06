#!/bin/bash

CLOCURL='https://github.com/AlDanial/cloc.git'
#TARGET='https://github.com/myliang/x-spreadsheet.git'
TARGET=$1
#RCPTEMAIL='michael.linder@gmail.com'
MAILRCPT=$2
OUTFILE='cloc.out'
SMTPSERVER='mail.michaellinder.net'

usage ()
{
    echo "Usage: cloc-mail.sh <scan target url> <destination email>"
    exit
}

if [ "$#" -ne 2 ]; then
    usage
fi

echo -n "SMTP username on $SMTPSERVER: "
read SMTPUSERNAME
echo -n "SMTP password: "
read -s SMTPPASSWORD
echo
echo

# install cloc if not already present in this directory
if [ ! -d "cloc" ]; then
    echo "Downloading cloc..."
    git clone $CLOCURL
fi

# get destination folder of target - will be the last part of the git url without the suffix
DESTFOLDER=`echo $TARGET | sed s_^.*/__g | sed s/.git$//g`

# clone target repository if project folder not already present in this directory
if [ ! -d "$DESTFOLDER" ]; then
    echo "Downloading target repository..."
    git clone $TARGET
fi

# perform CLOC scan on target directory.  Send output to STDOUT and OUTFILE
echo "Running cloc..."
echo -e "Results of cloc scan on $TARGET:\n\n" | tee "$OUTFILE"
./cloc/cloc $DESTFOLDER/ | tee -a "$OUTFILE"

# mail results
echo "Mailing results..."
curl --silent --show-error --url "smtps://$SMTPSERVER:465" --ssl-reqd --mail-from "$SMTPUSERNAME" --mail-rcpt "$MAILRCPT" --upload-file "$OUTFILE" --user "$SMTPUSERNAME:$SMTPPASSWORD"
echo "Done."
