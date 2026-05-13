#!/bin/bash
# zowe_operations.sh

# Provide direct path to zowe

#zowe_path=$(which zowe)
#if [ -z "$zowe_path" ]; then
#    echo "Zowe CLI not found. Please ensure it is installed and in your PATH."
#    exit 1
#fi      

# 1. Ensure npm binaries are in the PATH

export PATH=$PATH:$(npm config get prefix)/bin

zowe config set "profiles.myZos.properties.host" "$ZOWE_HOST"
zowe config set "profiles.myZos.properties.port" "$ZOWE_PORT"
zowe config set "profiles.myZos.properties.user" "$ZOWE_USERNAME"
zowe config set "profiles.myZos.properties.password" "$ZOWE_PASSWORD"

zowe config set "defaults.zosmf" "myZos"

echo "$ZOWE_HOST"

#export ZOWE_OPT_HOST=$ZOWE_HOST
#export ZOWE_OPT_PORT=$ZOWE_PORT
#export ZOWE_OPT_USERNAME=$ZOWE_USERNAME
#export ZOWE_OPT_PASSWORD=$ZOWE_PASSWORD

echo "I am at the beginning of the script now with Host = $ZOWE_HOST etc."

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
echo "$LOWERCASE_USERNAME"
# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
echo "Directory does not exist. Creating it..."
# Test step to display datasets from ZOS
#zowe zos-files list data-set "ZOWE_USER.UNEMP.*"
#
zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
echo "Directory already exists."
fi
#
# Initialize sparse checkout
#git sparse-checkout init --cone
#git sparse-checkout set "cobol-check"
#git checkout main
# Upload files
#export LC_ALL=EN_US.UTF-8
#export LANG=EN_US.UTF-8
#zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.9.jar" 
#zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck/bin" --recursive --binary-files "cobol-check-0.2.9.jar" 
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck/scripts" ----remote-encoding EBCDIC
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck/src" ----remote-encoding EBCDIC
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck/config.properties" ----remote-encoding EBCDIC

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
