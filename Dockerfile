FROM openjdk:8

RUN apt-get update && apt-get -y install libpulse0 \
      libgl1-mesa-glx pciutils mesa-utils \
      lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6
RUN useradd -ms /bin/bash android

USER android
WORKDIR /home/android
ENV SHELL=/bin/bash

RUN mkdir -p ~/android/sdk && \
    mkdir -p ~/.android/avd && \
    curl -k https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o tools_r25.2.3-linux.zip && \
    unzip tools_r25.2.3-linux.zip -d ~/android/sdk

ENV ANDROID_ROOT_SDK=/home/android/android/sdk
ENV PATH=$PATH:$ANDROID_ROOT_SDK/tools:$ANDROID_ROOT_SDK/tools/bin:$ANDROID_ROOT_SDK/platform-tools:$ANDROID_ROOT_SDK/emulator

RUN mkdir -p /home/android/.android && \
    touch /home/android/.android/repositories.cfg

RUN echo "y" | sdkmanager --update && sdkmanager "system-images;android-25;google_apis;armeabi-v7a" \
    "platforms;android-25" "build-tools;25.0.2"
