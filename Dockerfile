FROM adoptopenjdk/openjdk8

ENV ANDROID_SDK_ROOT /opt/android-sdk-linux
ENV JAVA_HOME /opt/java/openjdk 
ENV PATH /opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV ANDROID_COMPILE_SDK 29 
ENV ANDROID_BUILD_TOOLS 29.0.3 
ENV ANDROID_SDK_TOOLS 4333796

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq \
    && apt-get install -qq --no-install-recommends nodejs yarn wget tar unzip git python-dev build-essential \
    && rm -rf /var/lib/apt/lists/*
#lib32stdc++6 lib32z1

RUN wget -q https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O android-sdk.zip \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && unzip -d android-sdk-linux android-sdk.zip \
    && echo y | android-sdk-linux/tools/bin/sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" >/dev/null \
    && echo y | android-sdk-linux/tools/bin/sdkmanager "platform-tools" >/dev/null \
    && echo y | android-sdk-linux/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" >/dev/null \
    && yes | android-sdk-linux/tools/bin/sdkmanager --licenses \
    && rm -fr android-sdk.zip
