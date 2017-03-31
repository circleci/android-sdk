FROM ubuntu:16.04

# Create android user, with password android
RUN useradd -ms /bin/bash android && \
    echo "android:android" | chpasswd && \
    adduser android sudo

# Change default shell to bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Add the Oracle Java 8 PPA
RUN apt-get update && \
    apt-get install -y software-properties-common curl unzip git libpulse0 \
      libgl1-mesa-glx pciutils mesa-utils sudo \
      lib32z1 lib32ncurses5 lib32stdc++6 && \
    add-apt-repository ppa:webupd8team/java

# Set the Oracle Java license as read and accepted
# Install Oracle Java 8 JDK
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
      debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
      debconf-set-selections && \
    apt-get update && apt-get install -y oracle-java8-installer && \
    echo 'export JAVA_HOME=/usr/lib/jvm/java-8-oracle/jre/' >> /home/android/.bashrc

# Switch to user android and set default shell to bash
USER android
WORKDIR /home/android
ENV SHELL=/bin/bash

# Download and install Android SDK
RUN mkdir -p ~/android/sdk && \
    mkdir -p ~/.android/avd && \
    curl -k https://dl.google.com/android/repository/tools_r25.2.3-linux.zip -o tools_r25.2.3-linux.zip && \
    unzip tools_r25.2.3-linux.zip -d ~/android/sdk

# Set environmental variables
ENV ANDROID_HOME /home/android/android/sdk
ENV ADB_INSTALL_TIMEOUT 120
ENV PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Create dummy file to avoid warning
RUN mkdir -p /home/android/.android && \
    touch /home/android/.android/repositories.cfg

# Update SDK manager and install system image, platform and build tools
RUN echo "y" | sdkmanager --update && sdkmanager "system-images;android-25;google_apis;armeabi-v7a" \
    "platforms;android-25" "build-tools;25.0.2"
