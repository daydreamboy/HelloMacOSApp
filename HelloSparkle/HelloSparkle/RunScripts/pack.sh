#!/usr/bin/env bash

set -e
set -x

if [ "false" == "${THIS_SCRIPT_ALREADY_INVOKED:-false}" ]; then
  export THIS_SCRIPT_ALREADY_INVOKED="true"
else
  exit 0
fi

if [ "${CONFIGURATION}" != "Packaging" ]; then
  echo "[Warning] current scheme is not Release, just return"
  exit 0
fi


# Configure here...
XCWORKSPACE_NAME=HelloSparkle
SCHEME_NAME=HelloSparkle
PACKAGE_FOLDER=Package

WORKSPACE_PATH=${PROJECT_DIR}/${XCWORKSPACE_NAME}.xcworkspace
PACKAGE_PATH=${PROJECT_DIR}/${PACKAGE_FOLDER}

build_number=$(date +%Y%m%d/%H:%m:%S)

echo "[Info] $(xcodebuild -version)"

# Step1:
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "${INFOPLIST_FILE}"

#xcodebuild clean -workspace "${WORKSPACE_PATH}" -scheme "${SCHEME_NAME}" -configuration "${CONFIGURATION}" || exit

xcodebuild archive -workspace "${WORKSPACE_PATH}" -scheme ${SCHEME_NAME} -archivePath "${PACKAGE_PATH}/${SCHEME_NAME}.xcarchive" -quiet || exit 1
#xcodebuild -exportArchive -archivePath "${PACKAGE_PATH}/${SCHEME_NAME}.xcarchive" -exportPath "${PACKAGE_PATH}" -exportOptionsPlist ./ExportOptions.plist -quiet || exit
xcodebuild -exportArchive -archivePath "${PACKAGE_PATH}/${SCHEME_NAME}.xcarchive" -exportPath "${PACKAGE_PATH}" -quiet || exit

if [ -e "${PROJECT_DIR}/${PACKAGE_FOLDER}/${PRODUCT_NAME}.app" ]; then
  echo "[Info] export ipa file success"
else
  echo "[Error] export ipa file failed"
  exit 1
fi




