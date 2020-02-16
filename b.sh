OUTPUT_NAME=release
BASE_DIR=$(dirname $0)
TEMP_DIR=./_TEMP_
ASSETS_ARG=""

echo "Clean temp directory and create new"
rm -r ${TEMP_DIR}
mkdir ${TEMP_DIR} ${TEMP_DIR}/gen

echo "Check if res and src exist"
if [ ! -d "res" ] || [ ! -d "src" ]; then echo "fail" && exit; fi

echo "Generate R.java"
aapt package -m -J ${TEMP_DIR}/gen -M AndroidManifest.xml \
  -S res -I ${BASE_DIR}/android.jar

echo "Compile and convert to dex"
ecj -proc:none -cp ${BASE_DIR}/android.jar -cp ${TEMP_DIR}/gen \
  -d ${TEMP_DIR}/classes \
  -sourcepath src $(find src -type f -name "*.java") \
  $(find libs -type f -name "*.jar" | awk '{print "-cp " $1}')
if [ -d "libs" ]; then
  dx --dex --output=classes.dex ${TEMP_DIR}/classes ./libs; else
  dx --dex --output=classes.dex ${TEMP_DIR}/classes; fi

echo "Package resources"
if [ -d "assets/" ]; then ASSETS_ARG="-A assets"; fi
aapt package -f --no-version-vectors -I ${BASE_DIR}/android.jar \
  -S res -M AndroidManifest.xml ${ASSETS_ARG} -F ${OUTPUT_NAME}.apk
aapt add -f ${OUTPUT_NAME}.apk classes.dex

echo "Clean up"
rm -r classes.dex ${TEMP_DIR}