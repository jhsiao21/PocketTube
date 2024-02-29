## About
This app is built upon TMDB (The Movie Database) as its foundation, offering users the ability to browse a variety of movie and TV show information. It utilizes Firebase for login authentication, allowing users to register or directly log in using their Facebook or Google accounts. The backend database is powered by Firestore Database, enabling users to save and collect movies they are interested in.

Due to copyright concerns, the app uses YouTube trailers for video content, while the text and image data of the movies are sourced from TMDB. 

The following content includes technical details, feature introductions, and demos of the four main functions.


## Techniques

* Developed using Swift(UIKit) with an MVVM architectural pattern.
* Code auto layout programmatically, without using Storyboard.
* Application of TableView, CustomTableViewCell, CollectionView, and SearchBar
* Protocol-oriented programming
* Closure
* Firebase
* Testable API class and view model for Unit Test

## Introduction
### Authentication

![](images/Authentication.png)
![](images/LogIn.png)
![](images/SignUp.png)

[Demo video](https://www.youtube.com/watch?v=OS2JBtEoAFg)

### Home

![](images/Home.png)

[Demo video](https://www.youtube.com/watch?v=4F-UszejoWA)

### HotNewRelease

![](images/HotNewRelease.png)

[Demo video](https://www.youtube.com/watch?v=tuH_Y2zdWZs)

### Search

![](images/Search.png)

[Demo video](https://www.youtube.com/watch?v=BQcOcP1j3bY)

## Build
1. Drag your own GoogleService-Info.plist into the project.
2. Replace your FacebookAppID and FacebookClientToken in Info.plist file.
