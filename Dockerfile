FROM openjdk:8-jdk

ARG sdk_version=sdk-tools-linux-3859397.zip
ARG android_home=/opt/android/sdk

RUN apt-get update && apt-get install --yes xvfb

# Download and install Android SDK
RUN mkdir -p ${android_home} && \
    curl --output /tmp/${sdk_version} https://dl.google.com/android/repository/${sdk_version} && \
    unzip -q /tmp/${sdk_version} -d ${android_home}

# Set environmental variables
ENV ANDROID_HOME ${android_home}
ENV ADB_INSTALL_TIMEOUT 120
ENV DISPLAY :99
ENV PATH=${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

ADD dotfiles/repositories.cfg /root/.android/

RUN sdkmanager --update && yes | sdkmanager --licenses

# Update SDK manager and install system image, platform and build tools
RUN echo y | sdkmanager "platforms;android-25"
RUN echo y | sdkmanager "platform-tools"
RUN echo y | sdkmanager "build-tools;25.0.2"
RUN echo y | sdkmanager "extras;android;m2repository"
RUN echo y | sdkmanager "extras;google;m2repository"
RUN echo y | sdkmanager "system-images;android-25;google_apis;armeabi-v7a"
RUN echo y | sdkmanager "emulator"


