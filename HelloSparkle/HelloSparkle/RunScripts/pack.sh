#!/usr/bin/env bash

set -e
set -x

if [ "${CONFIGURATION}" != "Packaging" ]; then
  echo "[Warning] current scheme is not Release, just return"
  exit 0
fi

if [ "false" == "${THIS_SCRIPT_ALREADY_INVOKED:-false}" ]; then
  export THIS_SCRIPT_ALREADY_INVOKED="true"
else
  exit 0
fi

# Configure here...
xcworkspace_name=HelloSparkle
scheme_name=HelloSparkle
package_folder=Package
account_name=HelloSparkle
update_folder=Update

WORKSPACE_PATH=${PROJECT_DIR}/${xcworkspace_name}.xcworkspace
PACKAGE_PATH=${PROJECT_DIR}/${package_folder}
BUILD_VERSION=$(date +%Y%m%d/%H:%m:%S)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "[Info] $(xcodebuild -version)"

# Step2:
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion ${BUILD_VERSION}" "${INFOPLIST_FILE}"

# Step3 (Optional):
#xcodebuild clean -workspace "${WORKSPACE_PATH}" -scheme "${scheme_name}" -configuration "${CONFIGURATION}" || exit

# Step4:
xcodebuild archive -workspace "${WORKSPACE_PATH}" -scheme ${scheme_name} -archivePath "${PACKAGE_PATH}/${scheme_name}.xcarchive" -quiet || exit 1
# Step5:
xcodebuild -exportArchive -archivePath "${PACKAGE_PATH}/${scheme_name}.xcarchive" -exportPath "${PACKAGE_PATH}" -exportOptionsPlist "${SCRIPT_DIR}/ExportOptions.plist" -quiet || exit 1

if [ -e "${PROJECT_DIR}/${package_folder}/${PRODUCT_NAME}.app" ]; then
  echo "[Info] export app file success"
else
  echo "[Error] export app file failed"
  exit 1
fi

# Step6:
mkdir "${PROJECT_DIR}/${package_folder}/Update/"
cd "${PROJECT_DIR}/${package_folder}/"
zip -q -r "${PRODUCT_NAME}.zip" "${PRODUCT_NAME}.app"
cp "${PRODUCT_NAME}.zip" "${PROJECT_DIR}/${package_folder}/Update/"

# Step7:
if [ -z "${account_name}" ]; then
  "${PROJECT_DIR}"/Pods/Sparkle/bin/generate_appcast "${PROJECT_DIR}"/${package_folder}/Update
else
  "${PROJECT_DIR}"/Pods/Sparkle/bin/generate_appcast "${PROJECT_DIR}"/${package_folder}/Update --account ${account_name}
fi

echo "[Info] Create appcast.xml successfully"


