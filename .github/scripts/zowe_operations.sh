#!/bin/bash
# zowe_operations.sh

# Provide direct path to zowe
ZOWE_PATH="/usr/local/lib"
$ZOWE_PATH --version
# 1. Ensure npm binaries are in the PATH
export PATH=$PATH:$(npm config get prefix)/bin

# 2. Prevent Git Bash from remapping USS paths (useful for Windows users)
export MSYS_NO_PATHCONV=1

# Convert username to lowercase
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')
# Check if directory exists, create if it doesn't
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
echo "Directory does not exist. Creating it..."
# Test step to display datasets from ZOS
zowe zos-files list data-set "ZOWE_USER.UNEMP.*"
#
zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
echo "Directory already exists."
fi
# Upload files
zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive
        --binary-files "cobol-check-0.2.9.jar"
# Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"
