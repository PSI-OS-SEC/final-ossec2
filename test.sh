#!/bin/bash

function replica() {
  ipa server-find
  ipa-replica-manage list
}

function accounts() {

if [ -z $1 ]
then
 echo "SYNTAX: $0 $1 accounts all|group_name"
 exit 2
fi
if [ "$1" = "all" ]
then
 groups="webmasters itadmins itoperators"
else
 groups="$1"
fi

echo "**************************"
echo "Accounts and Groups"
echo "**************************"
for group in ${groups}
do
 echo "${group}"
 echo "++++++++++++++++++++++"
 ipa group-show ${group}
 if [ $? -eq 0 ]
 then
   echo "Exists ${group} = OK"
 else
   echo "Exists ${group} = FAILED"
 fi
 members=$(ipa group-show ${group}|grep 'Member users:'|cut -d: -f2|tr -d ",") 
 members_managers=$(ipa group-show ${group}|grep 'Membership managed by'|cut -d: -f2|tr -d ",") 
 #echo "${members}"
 if [ ! -z "${members}" ]
 then
  echo "Members Info"
  for member in ${members}
  do
   echo "==> ${member} - $(ipa user-show ${member}|grep -i 'Login shell'|cut -d: -f2|xargs)"
  done
 else
  echo "No members"
  echo "Members ${group} = FAILED"
 fi   
 if [ ! -z "${members_managers}" ]
 then
  echo "Members Managers"
  for manager in ${members_managers}
  do
   echo "==> ${manager} "
  done
 else
  echo "No managers"
  echo "Managers ${group} = FAILED"
 fi
done

}


