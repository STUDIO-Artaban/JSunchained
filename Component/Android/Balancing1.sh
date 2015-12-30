#!/bin/bash

cp Unchained/libs/armeabi/libUnchained.so Unchained/assets
cp Unchained/libs/armeabi/libgstreamer_android.so Unchained/assets
mv Unchained/assets/libUnchained.so Unchained/assets/libUnchained._so
mv Unchained/assets/libgstreamer_android.so Unchained/assets/libgstreamer_android._so

