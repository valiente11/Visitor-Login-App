Visitor Login Application
This repository contains the source code and documentation for my graduation project at European University of Lefke, Faculty of Engineering.
The project is a Visitor Login Application that integrates Flutter (mobile app), Node.js + MySQL (backend), and face recognition features.

📖 Project Description
The aim of this project is to design and implement a secure visitor login system that can be used at security checkpoints.
The system ensures that visitors can register, log in, and be authenticated through QR codes and face recognition technology.

<img width="500" height="1000" alt="image" src="https://github.com/user-attachments/assets/6821c968-cd14-4447-aa56-af2ac6492115" />


Main components:
Mobile Application (Flutter): User interface for visitors and security staff.
Backend Server (Node.js / Express): Handles user requests, database operations, and API endpoints.
Database (MySQL): Stores user records, login sessions, and encoding file references.
Face Recognition (Python/Flask): Provides face registration and authentication services.


Background Information
I used in this project multi-layered system in mobile development, server programming,
database management, and facial recognition. So I used, multiple programming languages,
frameworks, and development tools were together.

Required & Used software
 Flutter (Dart language)
I used the Flutter framework for mobile application side on my project. Flutter allows develop
apps for both Android and iOS, and I can also run my app in Xcode on a MacBook. Functions
such as face id , QR code scanning, form filling, and video playback,dark mode and light
mode,text size settings contrast settings were coding with using Flutter.

 Node.js & Express (JavaScript)
Node.js was used on the server side data transmission the mobile application from the
MySQL. Node.js is listening to mobile side and give the information to MySQL also in
MySQL information transfer the mobile side.

 MySQL (Database Management System)
All user information, survey results, the admin entry and exit times, application’s ratings are
stored in the MySQL database with tables.

 C++ (For Face Recognition Module)
In my project I used for face id I used c++ open cv library. This library is integrated in login
page analyzing the user's facial image.

 Python (For Optional Preprocessing or Integrations)
I used python in server side for face id. In the mobile development I didn’t use python.
Python is take the face image. After that open cv is encoding the numerical value for face
image. In the register process face and login face is compare if this face images is similar the
login process is succesfull.

<img width="200" height="500" alt="image" src="https://github.com/user-attachments/assets/8aab661d-b9f9-4e0a-b83c-07d551b84dfb" />





🚀 Features
📱 Flutter Mobile App
Register and log in visitors
QR code scanning
Notification system for admins

🔑 Authentication
Password-based login (hashed with SHA-256)
Face recognition-based login

🗄️ Database Integration
MySQL for storing user details, encodings, and visit history

🔒 Security
Data encryption and CORS enabled API





<img width="200" height="500" alt="image" src="https://github.com/user-attachments/assets/c426a21a-5f07-477e-b360-650670ea373a" />


<img width="200" height="500" alt="image" src="https://github.com/user-attachments/assets/f17089c7-77bd-4971-8102-ae1c0231e282" />





