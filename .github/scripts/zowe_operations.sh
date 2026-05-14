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

#export PATH=$PATH:/usr/lpp/java/J25.0_64/bin
#export JAVA_HOME=/path/to/your/jdk-25
#export PATH=$JAVA_HOME/bin:$PATH
#export PATH=$PATH:/usr/lpp/zowe/cli/node/bin

#echo "$ZOWE_HOST"

#export ZOWE_OPT_HOST=$ZOWE_HOST
#export ZOWE_OPT_PORT=$ZOWE_PORT
#export ZOWE_OPT_USERNAME=$ZOWE_USERNAME
#export ZOWE_OPT_PASSWORD=$ZOWE_PASSWORD

#echo "I am at the beginning of the script now with Host = $ZOWE_HOST etc."

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
# The following uploaded only the binary file and empty folders ignoring all text files due to the absence of encoding
#zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.9.jar" 

# The following commands are used to upload directories and subdirectories with their respective encoding type i.e. binary and EBCDIC (IBM-1047)
# They have been commented out since they were tried ony by one. --recursive -to copy all folders and subfolders and their contents.
#zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck/bin" --recursive --binary-files "cobol-check-0.2.9.jar" 
#zowe zos-files upload dir-to-uss "./cobol-check/scripts" "/z/$LOWERCASE_USERNAME/cobolcheck/scripts" --encoding "IBM-1047"
zowe zos-files upload dir-to-uss "./cobol-check/src" "/z/$LOWERCASE_USERNAME/cobolcheck/src" --recursive --encoding "IBM-1047"

# The follwoing is used to upload the lone file at the root of cobol-check. So, used file-to-uss and not dir-to-uss like in others. 
#zowe zos-files upload file-to-uss "./cobol-check/config.properties" "/z/$LOWERCASE_USERNAME/cobolcheck" --encoding "IBM-1047"

# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
