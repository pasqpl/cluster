#!/bin/bash


mesosdns=10.6.1.102
servicename="_demo4._tcp.marathon.mesos"

dnserror=0
wgeterror=0


function getserviceaddress(){
 dig +tries=1 +time=1 +short $servicename SRV @${mesosdns} | head -1 | awk '{ print $4":"$3 }'
 if [ $? -ne 0 ]; then
  dnserror=$[ $dnserror + 1 ]
 fi
}

while [ 1 ] ; do 
  out=$(wget --tries=1 -q -O - $(getserviceaddress))
  if [ $? -ne 0 ]; then
    wgeterror=$[ $wgeterror + 1 ]
  fi
  echo $out
  echo "Errors (wget/dns): $wgeterror , $dnserror"
done
