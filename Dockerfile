FROM ubuntu:14.04
ENV ANDROID_HOME /home/android/android/sdk
ENV ADB_INSTALL_TIMEOUT 120

RUN useradd -ms /bin/bash android && \
    echo "android:android" | chpasswd && \
    sudo adduser android sudo

# Change default shell to bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get -y install curl unzip libpulse0 \
      libgl1-mesa-glx pciutils mesa-utils \
      lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6

 # Add the Oracle Java 8 PPA
RUN apt-get update && \
    apt-get install -y software-properties-common curl unzip git libpulse0 \
      libgl1-mesa-glx pciutils mesa-utils \
      lib32z1 lib32ncurses5 lib32bz2-1.0 lib32stdc++6 && \
    add-apt-repository ppa:webupd8team/java

# Set the Oracle Java license as read and accepted
# Install Oracle Java 8 JDK
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
      debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
      debconf-set-selections && \
    apt-get update && apt-get install -y oracle-java8-installer && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/' >> /home/android/.bashrc

USER android
WORKDIR /home/android
ENV SHELL=/bin/bash

RUN mkdir -p ~/android/sdk && \
    mkdir -p ~/.android/avd && \
    curl -k https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o tools_r25.2.3-linux.zip && \
    unzip tools_r25.2.3-linux.zip -d ~/android/sdk

ENV ANDROID_HOME /home/android/android/sdk
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_ROOT_SDK/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator

RUN mkdir -p /home/android/.android && \
    touch /home/android/.android/repositories.cfg

RUN echo "y" | sdkmanager --update && sdkmanager "system-images;android-25;google_apis;armeabi-v7a" \
    "platforms;android-25" "build-tools;25.0.2"
