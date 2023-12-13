# fortest

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Brief Explanation of this project

This is an application that allows you to register and find lost items.
The purpose of this project is to make it easier and more convenient to find and register lost objects by utilizing computer vision.
It provides convenience to users by allowing the model to recognize and analyze the photo of the lost object to be registered to capture the features of the photo and automatically write the features instead of the author.
We hope this project will help society even a little.

# Description about files
## main.dart
It's literally a main screen and a home screen. We've got buttons and a bottom navigation bar to move to various screens.

----------------------------------------------------
## addGoods Folder
It is a folder with files that allow you to register lost items and check what you wrote.
### addGoods.dart
This is a screen where you can choose whether to upload a photo from the gallery or take a picture with a camera.
### imageDisplay.dart
It is a file that allows you to put uploaded photos into the model to extract features and create them.
### imsi_gul.dart
It's a file that displays all the previous writings as a list of big cards.
### seeMyGul - seeMyGul.dart
It's a file that allows you to see my writings at a glance with a small list of cards
### seeMyGul- GulDetailScreen.dart
This is a screen that shows the details of each post

----------------------------------------------------
## findGoods Folder
It's a screen where you can find lost items
### findGoodsdart
A file that displays a map of the Republic of Korea and markers for each administrative district of Seoul on the screen using Naver Map api. Tap a specific marker to go to the lost and found list of the administrative district.
### next_screen.dart
This is a screen that falls when you tap the marker in findGoods.dart. It shows the lost and found list of the administrative district.
### seeGuDetail.dart
It's a screen that contains the details of the post

----------------------------------------------------
## firebase Folder
It's literally a folder related to firebase
### firebase_options.dart
File with options for communicating with firebase
### gulItem.dart
It's a file that matches the variables in the flutter with the variables in the firebase

----------------------------------------------------
## mainScreen Folder
It's a folder with files on the home screen
### alarm.dart
A file that displays a notification for the keyword (it is still incomplete and needs to be made later)
### goodsList.dart
The file corresponds to the 'List of Lost and Found in My Village' tab.
### keywords.dart
It's a screen where you can add a keyword to be notified
### search.dart
This is a screen where you can search for the lost item you want to find.
You can search for major, minor, sub-categories, and features
### village.dart
This is a screen where you can set up your village.

----------------------------------------------------
## personalInfo Folder
It's literally a folder with files related to personal information
### findPassword.dart
It's literally a password finding file. (It's still incomplete.)
### join.dart
It's literally, a membership join screen
### personalInfo.dart
It's a file that can be moved to the screen related to personal information
### withdrawal.dart
Literally! a file where membership can be withdrawn
### login Folder
It's literally a folder containing files related to login
### login Folder - login.dart
Literally! It's a file that you can log in to
### login Folder - loginSuccess.dart
This is a screen that shows successful login, where you can set up your profile picture.
### login Folder - changeProfile Folder - changePassword.dart
This screen is used to change the password
### login Folder - changeProfile Folder - changeProfile.dart
This file is used when you want to change your profile. You can change your profile picture, change your password, and set up your village

----------------------------------------------------
### imsi_join.dart is for just test.
----------------------------------------------------
## Badges that I used in this project

![js](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![js](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![js](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![js](https://img.shields.io/badge/Powershell-2CA5E0?style=for-the-badge&logo=powershell&logoColor=white)
![js](https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white)
![js](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![js](https://img.shields.io/badge/Google-4285F4?logo=google&logoColor=fff&style=for-the-badge)
![js](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![js](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)
![js](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)


