#!/bin/sh

# process.sh
# Appcaster
#
# Created by Sean Dougall on 12/19/10.
# Copyright 2010 Figure 53. All rights reserved.


# Usage: process path/to/app path/to/keyfile

productname=`/usr/libexec/PlistBuddy -c "Print CFBundleName" $1/Contents/Info.plist`
productnamelowercase=`echo $productname | tr [:upper:] [:lower]`
versionnum=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $1/Contents/Resources/English.lproj/InfoPlist.strings`
buildnum=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $1/Contents/Info.plist`
newfolderpath=`echo $1 | sed "s|.app|/$versionnum-$buildnum|"`
keyfilepath=$2

# Make a new folder to put all our release products into
mkdir $newfolderpath

# Zip up the app. Note: this uses ditto instead of the zip command, because this is what Finder seems to use, and it results in a smaller file size.
zipfilename="$productname-$versionnum-$buildnum.zip"
zipfilepath="$newfolderpath/$zipfilename"
ditto -c -k --rsrc --keepParent $1 $zipfilepath

# Sign it and echo the signature.
sig=`openssl dgst -sha1 -binary < "$zipfilepath" | openssl dgst -dss1 -sign "$keyfilepath" | openssl enc -base64`
echo $sig
