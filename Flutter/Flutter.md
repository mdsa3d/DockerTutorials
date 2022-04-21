# [Flutter Apps](https://blog.codemagic.io/how-to-dockerize-flutter-apps/)
## Dockerfile
The Dockerfile that we have defined will download and install all the necessary tools required for developing Flutter apps.

This `FROM` command creates a layer from the `ubuntu:20.04` Docker image.
```Dockerfile
FROM ubuntu:20.04
```
Upon using this `RUN` command, all the necessary packages are downloaded and installed using `apt`.<br>
`curl git unzip xz-utils zip libglu1-mesa` is required by Flutter SDK
`openjdk-8-jdk` is required by Android SDK<br>
`wget` will be used for downloading some Android tools
```Dockerfile
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
```
Add a new non-root user called developer, set it as the current user, and change the working directory to its home directory.
```Dockerfile
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer
```
Create some folders where the Android SDK will be installed. Also, set the environment variable ANDROID_SDK_ROOT to the correct directory path—this will be used by Flutter.
```Dockerfile
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg
```
Download the latest SDK tools. Unzip them and move them to the correct folder. Then, we will use `sdkmanager` to accept the Android Licenses and download the packages that will be used during app development. Finally, I have added the path to `adb`.<br>

Here, the specified packages are for API 29, but if you want to use a different Android version, then specify it here.
```Dockerfile
RUN wget -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --licenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "patcher;v4" "platform-tools" "platforms;android-29" "sources;android-29"
ENV PATH "$PATH:/home/developer/Android/sdk/platform-tools"
```
Set up Flutter by cloning it from the GitHub repository, and add the PATH environment variable for running flutter commands from the terminal.
```Dockerfile
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"
```
At last, run the `flutter doctor` command for downloading the Dart SDK and for checking whether Flutter is set up properly.
```Dockerfile
RUN flutter doctor
```


## [devcontainer.json](https://code.visualstudio.com/docs/remote/containers#_creating-a-devcontainerjson-file)
Details regarding the properties we have used inside the devcontainer.json file are listed below:
<ul>
<li><b>name:</b> A display name for the container.</li>

<li><b>context:</b> The path that the Docker build should be run from relative to devcontainer.json.</li>

<li><b>dockerFile:</b> The location of a Dockerfile that defines the contents of the container. The path is relative to the devcontainer.json file.</li>

<li><b>remoteUser:</b> The name of the user that will be used in the container.</li>

<li><b>mounts:</b> An array with mount points that should be added to the container at runtime. Here, we have mounted /dev/bus/usb so that the container can detect any Android device connected to the system (NOT APPLICABLE for macOS and Windows).</li>

<li><b>settings:</b> Adds default settings.json values into a container/machine-specific settings file.</li>

<li><b>runArgs:</b> An array with string values that should be valid Docker arguments. We use --privileged to make sure that the container can access devices connected to the system.</li>

<li><b>extensions:</b> An array of extension IDs that specify the extensions that should be installed inside the container when it is created. dart-code.flutter is the official extension for Flutter development.</li>

<li><b>workspaceMount:</b> Overrides the default local mount point for the workspace.</li>

<li><b>workspaceFolder:</b> Sets the default path that VS Code should open when connecting to the container.</li>
