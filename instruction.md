# Task: Build an MVP of a local Wi-Fi file transfer application using Flutter

## Goal

Create a working prototype of a Flutter application that transfers files between macOS and iOS over the local Wi-Fi network without using cloud services or the Internet.

The project must use a single Flutter codebase for both platforms.

The architecture should be clean, modular, and easy to extend.

---

## Platforms

* macOS
* iOS

---

## Technologies

Use only:

* Flutter (latest stable)
* Dart
* dart:io
* HttpServer
* HttpClient
* Streams
* mDNS / Bonjour for automatic device discovery
* BLOC for state management
* go_router for navigation

Do NOT implement FTP.

Do NOT use Firebase or any cloud services.

Communication must happen entirely inside the local network.

---

## MVP Features

### macOS

The Mac acts as the server.

Implement:

* Start server
* Stop server
* Display current IP
* Advertise service using Bonjour (mDNS)
* Select a shared folder
* List files inside the folder
* Allow downloading files
* Receive uploaded files
* Display upload/download progress
* Log connected devices

---

### iOS

The iPhone acts as the client.

Implement:

* Automatically discover Macs on the network using Bonjour
* Show discovered devices
* Connect with one tap
* Request the file list
* Browse folders
* Download files
* Upload files selected from Files app
* Display transfer progress

---

## HTTP API

Implement endpoints such as:

GET /files

Returns JSON list of files.

GET /download/{filename}

Streams a file.

POST /upload

Accepts multipart/form-data.

GET /ping

Returns server status.

---

## File Transfer

Use streaming only.

Do NOT load the entire file into memory.

Example:

File.openRead()

↓

HttpResponse.addStream()

For uploads:

HttpRequest

↓

File.openWrite()

Large files (10 GB+) must theoretically work.

---

## Discovery

Use Bonjour / mDNS.

The client must automatically discover available servers.

No manual IP address entry.

---

## UI

Simple but clean.

macOS:

* Start Server
* Stop Server
* Shared Folder
* Connected Devices
* Activity Log

iOS:

* Device List
* File Browser
* Upload Button
* Download Progress
* Transfer History

---

## Architecture

Use Clean Architecture.

Suggested layers:

presentation/

data/

domain/


Repositories should hide networking details.

Networking should be replaceable.

Business logic should not depend on Flutter widgets.
EXACTLY SIMULAR PROJECT STRUCTURE: /Volumes/SSD/Programming/StudioProjects/sinergy_hub 
---

## Code Quality

* Null safety
* SOLID principles
* Dependency Injection
* BLOC
* Small reusable widgets
* Documentation for public APIs
* Meaningful class names

---

## Non-goals

Do NOT implement:

* User accounts
* Authentication
* Encryption
* Background sync
* Resume transfers
* File previews
* Image thumbnails
* Database
* Cloud storage

Keep the prototype as small as possible.

---

## Expected Result

At the end, I should be able to:

1. Launch the macOS application.
2. Click "Start Server".
3. Open the iPhone application.
4. Automatically discover the Mac.
5. Browse the shared folder.
6. Download files.
7. Upload files back to the Mac.
8. Watch transfer progress.

The application should be structured so future features (authentication, encryption, background transfers, thumbnails, search, sync) can be added without major refactoring.
