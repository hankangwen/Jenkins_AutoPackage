#!/bin/bash

# setup a few variables
REQUIRED_SPACE="50 Mb"
MY_PATH=`dirname "$0"`
LOCKFILE="${MY_PATH}/migration-assistant.lock"
OUTFILE="${MY_PATH}/SDK.zip"
OUTFILE_KEYCHAIN="${MY_PATH}/Keychain.zip"

# fool-proof checks
if id -Gn | grep -q -w admin; then true; else
	echo ""
	echo "-------------------------------------------------------------------------------"
	echo "Looks like you're trying to run this script with a non-admin Mac user account."
	echo "Admin rights are needed to migrate your iOS identities from the Mac's Keychain."
	echo "Please run this script again from an user account with administrator rights."
	echo "-------------------------------------------------------------------------------"
	echo ""
	exit
fi
if [ "_${MY_PATH}_" = "_._" ]; then
	echo ""
	echo "-------------------------------------------------------------------------------"
	echo "Looks like you're trying to run this script from a Terminal session."
	echo "This does not work as expected. Just double-click the file from Finder instead."
	echo "-------------------------------------------------------------------------------"
	echo ""
	exit
fi
if [ -f "${LOCKFILE}" ]; then
	echo ""
	echo "-------------------------------------------------------------------------------"
	echo "Looks like the migration assistant is already running. Why not let it finish?"
	echo "If it's not, please delete ${LOCKFILE}"
	echo "and run this script again."
	echo "-------------------------------------------------------------------------------"
	echo ""
	exit
fi

# clear the console first
clear && printf '\e[3J'
echo ""
echo "-------------------------------------------------------------------------------"
echo "Welcome! This automated script will copy a few files from the iOS SDK that are "
echo "necessary for the iOS Build Environment to work."
#echo "These files will be copied on the USB key at ${OUTFILE}"
echo "-------------------------------------------------------------------------------"

# prevent another copy of ourselves from showing up
touch "${LOCKFILE}"

# step 1
echo ""
echo -n "Step 1. Let's see if Xcode is installed and if we have the iOS SDK... "
XCODE_PATH=""
if [ -d "/Applications/Xcode-beta.app" ]; then
	XCODE_PATH="/Applications/Xcode-beta.app"
elif [ -d "${HOME}/Downloads/Xcode-beta.app" ]; then
	XCODE_PATH="${HOME}/Downloads/Xcode-beta.app"
elif [ -d "/Applications/Xcode.app" ]; then
	XCODE_PATH="/Applications/Xcode.app"
fi
test "_${XCODE_PATH}_" = "__" && XCODE_PATH=`find / -name Xcode-beta.app`
test "_${XCODE_PATH}_" = "__" && XCODE_PATH=`find / -name Xcode.app`
XCTCHAIN_PATH="${XCODE_PATH}/Contents/Developer/Toolchains/XcodeDefault.xctoolchain"
PLATFORM_PATH="${XCODE_PATH}/Contents/Developer/Platforms/iPhoneOS.platform"
SDK_PATH="${PLATFORM_PATH}/Developer/SDKs"
THE_SDK=`ls -t ${SDK_PATH}|awk '{print $0}'|head -n 1`
if [ ! -f "${XCODE_PATH}/Contents/Info.plist" -o "_${THE_SDK}_" = "__" ]; then
	echo "no."
	echo ""
	echo "iOS SDK not found."
	echo "Please download and install Xcode (it's free) from the Mac App Store"
	echo "before running this script."
	rm -f "${LOCKFILE}"
	exit
fi
echo "yes."

# step 2
echo ""
echo -n "Step 2. Getting Xcode's version.plist and the needed libraries... "
RT_LIB=`find "${XCODE_PATH}/" -name libclang_rt.ios.a`
CPPELEVENDIR=`find "${XCTCHAIN_PATH}/" -name v1`
if [ ! -f "${XCODE_PATH}/Contents/version.plist" -o ! -f "${RT_LIB}" -o ! -d "${CPPELEVENDIR}" ]; then
	echo "fail."
	echo ""
	if [ ! -f "${XCODE_PATH}/Contents/version.plist" ]; then
		echo "Xcode's version.plist not found."
	elif [ ! -f "${RT_LIB}" ]; then
		echo "No Clang runtime library found."
	else
		echo "C++11 libraries not found."
	fi
	echo "Your Xcode version must be ages old !?"
	echo "Please download and install a RECENT version of Xcode that has an iOS"
	echo "SDK in it."
	rm -f "${LOCKFILE}"
	exit
fi
rm -f "${OUTFILE}"
zip -jq "${OUTFILE}" "${RT_LIB}"
cd "${CPPELEVENDIR}/.."
mkdir -p "/tmp/__iosbuildenv_temp/lib/c++"
cp -R v1 "/tmp/__iosbuildenv_temp/lib/c++"
cp "${XCODE_PATH}/Contents/version.plist" "/tmp/__iosbuildenv_temp/xcode-version.plist"
cd "/tmp/__iosbuildenv_temp"
sw_vers|grep BuildVersion|awk '{print $2}' > osx-build
# with symlinks: zip -uryq
zip -urq "${OUTFILE}" "." || ( echo ""; echo "Looks like there's not enough space on your USB key."; echo "Please try again with a key with at least ${REQUIRED_SPACE} free."; rm -f "${LOCKFILE}"; exit; )
rm -rf "/tmp/__iosbuildenv_temp"
echo "done."

# step 3
echo ""
echo -n "Step 3. Zipping 'System' and 'usr' directories from ${THE_SDK}..."
cd "${SDK_PATH}/${THE_SDK}"
# with symlinks: zip -uryq
zip -urq "${OUTFILE}" "System" "usr" || ( echo ""; echo "Looks like there's not enough space on your USB key."; echo "Please try again with a key with at least ${REQUIRED_SPACE} free."; rm -f "${LOCKFILE}"; exit; )
echo "done."

# step 4
echo ""
echo -n "Step 4. Saving the platform's Info.plist and version.plist... "
cd "${PLATFORM_PATH}"
if [ ! -f "Info.plist" -o ! -f "version.plist" ]; then
	echo "Platform's Info.plist and/or version.plist not found."
	echo "Your Xcode version must be ages old !?"
	echo "Please download and install a RECENT version of Xcode that has an iOS"
	echo "SDK in it."
	rm -f "${LOCKFILE}"
	exit
fi
zip -urq "${OUTFILE}" "Info.plist" "version.plist" || ( echo ""; echo "Looks like there's not enough space on your USB key."; echo "Please try again with a key with at least ${REQUIRED_SPACE} free."; rm -f "${LOCKFILE}"; exit; )
echo "done."

# step 5
echo ""
echo -n "Step 5. Exporting the existing iOS code signing identites... "
mkdir -p "/tmp/__iosbuildenv_temp"
cd "/tmp/__iosbuildenv_temp"
# look for iOS developer identities in the keychain and have a list of their names
CERT_IDS=`security find-identity -v -p codesigning|grep iPhone|awk '{print $2}'`
CERT_NAMES=`security find-identity -v -p codesigning|grep iPhone|awk -F\" '{print $2}'`
if [ "_${CERT_NAMES}_" != "__" ]; then
	# iterate through each of them and export the corresponding certificates
	IDENTITY_COUNT=0
	while read -r CERT_NAME; do
		CERT_FILENAME="`echo ${CERT_NAME}|sed 's/[:\\/]//g'`.cer"
		security find-certificate -c "${CERT_NAME}" -p | /usr/bin/openssl x509 -inform pem -out "${CERT_FILENAME}" -outform der
		IDENTITY_COUNT=$(expr ${IDENTITY_COUNT} + 1)
	done <<< "${CERT_NAMES}"
	# now export all private keys and secure them with a passphrase
	osascript -e 'display dialog "macOS will now ask you to enter your account password in order to export your iOS code signing identities.\n\nPLEASE NOTE: it is recommended to select Always allow to prevent the password prompt from showing up multiple times." buttons {"Got it"} with title "Migration Assistant" with icon caution' > /dev/null
	#security export -k /Library/Keychains/System.keychain -t identities -f pkcs12 -P w0bbit | /usr/bin/openssl pkcs12 -nodes -nocerts -passin pass:w0bbit 2> /dev/null|csplit -f private_key - '/^Bag Attributes/' > /dev/null 2>&1
	security export -t identities -f pkcs12 -P w0bbit | /usr/bin/openssl pkcs12 -nodes -nocerts -passin pass:w0bbit 2> /dev/null > temp_keys
	if [ `stat -f%z temp_keys` -gt 255 ]; then
		KEY_COUNT=`cat temp_keys|grep -c -e "^Bag Attributes"`
		if ((KEY_COUNT > 1)); then
			csplit -f private_key temp_keys '/^Bag Attributes/' {$((KEY_COUNT - 2))} > /dev/null 2>&1
		else
			cp temp_keys private_key
		fi
		# make sure the user supplies a reasonable passphrase (FIXME: check for special characters too)
		KEYPASS=""
		while [ "_${KEYPASS}_" = "__" -o ${#KEYPASS} -lt 4 ]; do
			KEYPASS=`osascript -e 'display dialog "Now please enter a passphrase to protect during their transfer the private key(s) that were found on your Mac.\n\n4 characters minimum, a mix of the ranges [A-Z][a-z][0-9] is safe (DO NOT USE SPECIAL CHARACTERS!)\n\nRemember that passphrase, you will need it in Windows to sign your iOS apps." with title "Migration Assistant" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null`
		done
		for KEYFILE in private_key*; do
			# remove duplicates before encryption
			for OTHERFILE in private_key*; do
				test "_${KEYFILE}_" == "_${OTHERFILE}_" && continue
				test ! -e "${KEYFILE}" && continue
				test ! -e "${OTHERFILE}" && continue
				cmp "${KEYFILE}" "${OTHERFILE}" > /dev/null && rm -f "${OTHERFILE}"
			done
			test ! -e "${KEYFILE}" && continue
			# now write final key; preserve key name and store public modulus and exponent
			KEYNAME=`cat "${KEYFILE}"|grep friendlyName|awk -F': ' '{print $2}'`
			KEYMODULUS=`openssl rsa -inform PEM -text -noout < "${KEYFILE}"|tr -d :|sed -e ':a' -e 'N' -e '$!ba' -e 's/\n    //g'|grep modulus|cut -c 8-|tr '[:lower:]' '[:upper:]'`
			KEYEXPONENT=`openssl rsa -inform PEM -text -noout < "${KEYFILE}"|grep publicExponent|printf "%X\n", $2`
			echo "Bag Attributes" > "${KEYFILE}.key"
			echo "    friendlyName: ${KEYNAME}" >> "${KEYFILE}.key"
			echo "    publicModulus: ${KEYMODULUS}" >> "${KEYFILE}.key"
			echo "    publicExponent: ${KEYEXPONENT}" >> "${KEYFILE}.key"
			openssl rsa -des3 -in "${KEYFILE}" -passout pass:"${KEYPASS}" >> "${KEYFILE}.key" 2> /dev/null
			rm -f "${KEYFILE}"
		done
		KEYPASS=""
	else
		osascript -e 'display dialog "No private key related to an iOS code signing identity was exported.\n\nIf this was not an authorization problem, you will need to create a new code signing identity from scratch. Please refer to the documentation on how to do so." buttons {"Got it"} with title "Migration Assistant" with icon caution' > /dev/null
	fi
	rm -f temp_keys
	echo "${IDENTITY_COUNT} found."
else
	echo "none found."
fi
# gather all the provisioning profiles in our temporary directory alongside the certificates and private keys
# preserve mtime during copy (-p), this will make older profiles be overwritten (mv) by newer copies
cp -p ~/Library/MobileDevice/Provisioning\ Profiles/*.mobileprovision . 2>/dev/null
if [ "_`ls -t *.mobileprovision 2> /dev/null`_" != "__" ]; then
	for PROFILE in `ls -t *.mobileprovision`; do
		NAME=`cat "${PROFILE}" | grep -a "<string>" | sed -e 's/<string>//g' -e 's/<\/string>//g' | awk '{$1=$1};1' | head -n 2 | head -n 1`
		TEAMID=`cat "${PROFILE}" | grep -a "<string>" | sed -e 's/<string>//g' -e 's/<\/string>//g' | awk '{$1=$1};1' | head -n 2 | tail -n 1`
		mv "${PROFILE}" "${NAME} (${TEAMID}).mobileprovision"
	done
fi
rm -f "${OUTFILE_KEYCHAIN}"
if [ "_`ls -t * 2> /dev/null`_" != "__" ]; then
	zip -jq "${OUTFILE_KEYCHAIN}" * || ( echo ""; echo "Looks like there's not enough space on your USB key."; echo "Please try again with a key with at least ${REQUIRED_SPACE} free."; rm -f "${LOCKFILE}"; exit; )
fi
rm -rf "/tmp/__iosbuildenv_temp"

# release the fool-proof lock and bail out
rm -f "${LOCKFILE}"

echo ""
echo "-------------------------------------------------------------------------------"
echo "Finished."
echo "I have all the files I need. Now please reboot into Windows, open your USB key"
echo "there and run the second part of the migration assistant."
echo "-------------------------------------------------------------------------------"
