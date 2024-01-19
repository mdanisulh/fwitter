<a name="readme-top"></a>
<br />
<div align="center">
  <a href="https://github.com/mdanisulh/fwitter">
    <img src="assets/png/logo.png" alt="Logo" width="250" height="250">
  </a>

<a href="https://github.com/mdanisulh/fwitter"><strong>Fwitter</strong>
  </a>
  <p align="center">
    A Twitter clone built with Flutter and Appwrite.
    <br />
    <a href="https://github.com/mdanisulh/fwitter/issues">Report Bug</a>
    ·
    <a href="https://github.com/mdanisulh/fwitter/issues">Request Feature</a>
  </p>
</div>

## Features
- Users can sign up/login
- Post Tweets (includes Text & Images)
- Reply to Tweets
- Like Tweets
- Users can retweet other User's tweets
- Follow other Users
- View other User's Profile
- View other User's Tweets
- View other User's Followers and Following Count
- Search Users
- Edit their own Profile


## Installation
> **Note:** There are no prebuilt executable files available for Windows, IOS and MacOS. To install Fwitter for any of these platforms you have to build it on your own.

### Website
You can access the web app [here](https://mdanisulh.github.io/fwitter).
> **Note:** Although most features in the web app work as expected, there are some known issues. Links preview does not work, and users are unable to change their profile photo due to [CORS issues](https://github.com/flutter/flutter/issues/119297) on the Flutter web app.

### Android
You can install **Fwitter** for android from [here](https://github.com/mdanisulh/fwitter/releases/tag/v1.0.0). There are 4 apks for android. If you are sure about the processor architecture your device uses you can download and install that respective apk. Otherwise you can download and install the [universal apk](https://github.com/mdanisulh/fwitter/releases/download/v1.0.0/android-app-universal.apk).
> **Note:** The universal apk takes up more space but is compatible with both 32 and 64 bit processor architecture.

### Linux
You can intall the tar file for Linux from [here](https://github.com/mdanisulh/fwitter/releases/download/v1.0.0/linux-x86_64.tar.gz). After extracting it you will be able to see some bash scripts and fwitter directory. You can start the app by executing the binary file in the fwitter directory.
To permanently install the app and display it on your Application Menu you can open a terminal and execute the following command
```
./install.sh
```
To uninstall the application you can open a terminal in the extracted directory and execute the following command
```
./uninstall.sh
```
