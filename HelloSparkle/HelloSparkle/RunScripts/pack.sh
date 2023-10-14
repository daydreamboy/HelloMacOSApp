#!/usr/bin/env bash

set -e
set -x

# Configure here...
XCWORKSPACE_NAME=HelloSparkle
SCHEME_NAME=HelloSparkle
PACKAGE_FOLDER=Package

WORKSPACE_PATH=${PROJECT_DIR}/${XCWORKSPACE_NAME}.xcworkspace
PACKAGE_PATH=${PROJECT_DIR}/${PACKAGE_FOLDER}

build_number=$(date +%Y%m%d/%H:%m:%S)
info_plist=$INFOPLIST_FILE

echo "[Info] $(xcodebuild -version)"

if [ "${CONFIGURATION}" != "Release" ]; then
  echo "[Warning] current scheme is not Release, just return"
  exit 0
fi

# Step1:
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $build_number" "${info_plist}"

#xcodebuild clean -workspace "${WORKSPACE_PATH}" -scheme "${SCHEME_NAME}" -configuration "${CONFIGURATION}" || exit

#xcodebuild archive -workspace "${WORKSPACE_PATH}" -scheme ${SCHEME_NAME} -archivePath "${ARCHIVE_PATH}" -quiet || exit
#xcodebuild -exportArchive -archivePath "${PACKAGE_PATH}/${SCHEME_NAME}.xcarchive" -exportPath "${PACKAGE_PATH}" -exportOptionsPlist ./ExportOptions.plist -quiet || exit

if [ -e "${PROJECT_DIR}/${PACKAGE_FOLDER}/${PRODUCT_NAME}.app" ]; then
  echo "[Info] export ipa file success"
else
  echo "[Error] export ipa file failed"
  exit 1
fi




