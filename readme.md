# build apk from source on termux

## install

```sh
pkg in aapt dx ecj
xz -d android.jar.xz
chmod +x b.sh
```

## usage

```sh
cd example.test1
../b.sh
cp *.apk /sdcard/
```

## license

android.jar.xz comes from android sdk, other files licensed under WTFPL