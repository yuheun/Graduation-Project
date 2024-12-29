# Graduation-Project
## Lost & Found Vision

The 'Lost&Found Vision' project is a community-based lost and found recognition and sharing application. This application utilizes location-based services and image processing technology to automatically recognize and categorize lost items, sharing them with the community to assist in their recovery.

### Overall Process
<img width="717" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/036ccfa8-ab79-4db7-800e-bca8bc00e6fa">

1. **User Finds an Object**: Display an image of a person discovering a lost item and picking it up.
2. **Photo Capture**: Show the user taking a picture of the item with their smartphone.
3. **Object Detection**: Illustrate the app interface with the uploaded photo, highlighting the item with a bounding box as the app analyzes the image.</br>
  <img width="548" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/037ed463-b2df-4cd0-b1a0-42dcd834015c">

4. **Information Extraction**: Present the app identifying and extracting features such as color, shape, or any distinctive marks and categorizing the information into four levels: major category, intermediate category, minor category, and final classification, for storage in a database.</br>
   <img width="420" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/37f3924a-21f0-4339-a9a5-7699699dcf26"></br>
   <img width="514" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/3d3a1939-92d1-46a8-8120-5644f26703ca">

5. **Location Tagging**: Include a graphic or icon that signifies the recording or inputting of the item's location, such as a map icon.</br>
   <img width="233" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/578208d3-cf20-467e-b171-f3660a7037e9">

6. **Database Upload**: Demonstrate that the extracted information is being uploaded to a database, indicated by a cloud upload icon or similar imagery.</br>
     <img width="349" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/2cbde90f-2dfc-493d-90b9-a60f5bb53baf">

7. **Community Sharing**: Depict how the item's information is shared within a community or network, possibly shown as interconnected user profiles or icons.
8. **Owner Searches and Finds Item**: Finally, show a pleased owner locating their lost item through the app, with an image of a joyful reunion with the item.

### Instructions for Use
1. **Uploading an Item:**
   - Launch the application and select the "Upload Item" feature.
   - Provide an image and information about the item you wish to upload.
   - Click the upload button to post your item.

2. **Searching for an Item:**
   - Use the "Search for Item" function to find items using keywords or categories.
   - Review the search results and locate the item of interest.

3. **Setting Notifications:**
   - In the "Notifications" menu, set up alerts for your desired keywords.
   - Receive notifications when an item related to your specified keywords is uploaded.


## Database
<img width="552" alt="image" src="https://github.com/GraduationProjectTeam7/GraduationProject/assets/85086390/0356af5b-aaf3-4507-897d-79a6b098a06a">


## Map
Obtaining and using Naver Map API permission from Naver Cloud Platform
</br>
![naver api](https://github.com/berry1015/fortest/assets/120501910/621f2bca-9916-4317-884d-ad58a7bb0c81)

In-app Map Execution Screen
</br>
![map](https://github.com/berry1015/fortest/assets/120501910/cf56bd7d-ee11-4670-bae6-52c9b41430e1)

- Marking Seoul's administrative autonomous districts with markers
- Display the name of the administrative autonomous districts on the marker

## Object Detection
Use Tensorflow Object Detection api to detect objects.</br>
![](https://www.tensorflow.org/static/images/tf_logo_social.png)
[API] : https://github.com/tensorflow/models/tree/master/research/object_detection


This api is pretrained model that used COCO Dataset.


We added AirPods and wallets to the label map according to the characteristics of our application.

- [Wallet dataset] : https://universe.roboflow.com/project-a5ktq/wallets/dataset/2

- [Airpod dataset] : https://universe.roboflow.com/yolov5-oi1fm/detect-airpod/dataset/2

Output of detection
![detectionoutput](./assets/image/DetectionOutput.jpg)



## Description about files (Explanation of codes)
<img src="https://github.com/berry1015/fortest/assets/79952916/f6a041a6-06a4-45cf-b896-d61ee966d621" alt="mainscreen" width="210" height="400">
<img src="https://github.com/berry1015/fortest/assets/79952916/15c8bb06-046e-478a-aa19-843587510cbc" alt="findGoods" width="210" height="400">
<img src="https://github.com/berry1015/fortest/assets/79952916/b373017f-5ea1-484c-a68e-82efb14e058e" alt="search" width="210" height="400">
<img src="https://github.com/berry1015/fortest/assets/79952916/e2fbf911-09c0-46de-a60f-11a8fb846ced" alt="login" width="210" height="400">
</br>
You can see a description of the files through the link below.</br>
https://github.com/berry1015/fortest/blob/main/README.md


## Technology Stack
- front: Flutter
- database: Firebase
- image processing: OpenCV
- map service: Naver API


----------------------------------------------------
## Badges that We used in this project

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


