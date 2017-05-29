FROM ubuntu:16.04

ARG sdk_version=sdk-tools-linux-3859397.zip
ARG android_home=/opt/android/sdk

# Add the Oracle Java 8 PPA
RUN apt-get update && \
    apt-get install --yes software-properties-common curl unzip git libpulse0 \
      libgl1-mesa-glx pciutils mesa-utils sudo \
      lib32z1 lib32ncurses5 lib32stdc++6 && \
    add-apt-repository ppa:webupd8team/java

# Set the Oracle Java license as read and accepted
# Install Oracle Java 8 JDK
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | \
      debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \
      debconf-set-selections && \
    apt-get update && apt-get install -y oracle-java8-installer

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle/jre/

# Download and install Android SDK
RUN mkdir -p ${android_home} && \
    curl --output /tmp/${sdk_version} https://dl.google.com/android/repository/${sdk_version} && \
    unzip /tmp/${sdk_version} -d ${android_home}

# Set environmental variables
ENV ANDROID_HOME ${android_home}
ENV ADB_INSTALL_TIMEOUT 120
ENV PATH=${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

ADD dotfiles/repositories.cfg /root/.android/

# Create dummy file to avoid warning
#RUN mkdir -p /home/android/.android && \
#    touch /home/android/.android/repositories.cfg

RUN sdkmanager --update && yes | sdkmanager --licenses

# Update SDK manager and install system image, platform and build tools
RUN echo y | sdkmanager "platforms;android-25"
RUN echo y | sdkmanager "platform-tools"
RUN echo y | sdkmanager "build-tools;25.0.2"
RUN echo y | sdkmanager "extras;android;m2repository"
RUN echo y | sdkmanager "extras;google;m2repository"
RUN echo y | sdkmanager "system-images;android-25;google_apis;armeabi-v7a"

# Overwrite the old emulator with the latest one
#RUN cp $ANDROID_HOME/emulator/emulator $ANDROID_HOME/tools/emulator

# /root/.android/repositories.cfg
