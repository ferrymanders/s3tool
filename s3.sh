#!/bin/bash

# Maintainer : Ferry Manders <github@blackring.net>

# This file expects a .s3creds file in user home
# The .s3creds file should contain the keys s3Key, s3Secret and s3Host
# example:
# s3Key="<access key>"
# s3Secret="<secret key>"
# s3Host="s3.host.tld"

source ~/.s3creds

function putS3
{
  fullFilePath="$1"
  bucket="$2"

  file="${fullFilePath##*/}"
  path=$(dirname "${fullFilePath}")

  resource="/${bucket}/${file}"
  contentType=$(file -b --mime-type "${path}/${file}")
  dateValue=$(date -R)
  stringToSign="PUT\n\n${contentType}\n${dateValue}\n${resource}"
  signature=$(echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64)
  curl -X PUT -T "${file}" \
    -H "Host: ${bucket}.${s3Host}" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${s3Key}:${signature}" \
    "https://${bucket}.${s3Host}/${file}"

  echo "# File saved, to retrieve run : ./s3.sh get ${file} ${bucket} \"${contentType}\" <location_to_save_to>"
}

function getS3
{
  file="$1"
  bucket="$2"
  contentType="$3"
  fileSaveLoc="$4"

  resource="/${bucket}/${file}"
  contentType="${contentType}"
  dateValue=$(date -R)
  stringToSign="GET\n\n${contentType}\n${dateValue}\n${resource}"
  signature=$(echo -en ${stringToSign} | openssl sha1 -hmac ${s3Secret} -binary | base64)
  curl \
    -H "Host: ${bucket}.${s3Host}" \
    -H "Date: ${dateValue}" \
    -H "Content-Type: ${contentType}" \
    -H "Authorization: AWS ${s3Key}:${signature}" \
    "https://${bucket}.${s3Host}/${file}" -o "$fileSaveLoc"
}

action="$1"
file="$2"
bucket="$3"
contentType="$4"
saveFileLoc="$5"


case $action in
  put) putS3 "$file" "$bucket" ;;
  get) getS3 "$file" "$bucket" "$contentType" "$saveFileLoc" ;;
esac
