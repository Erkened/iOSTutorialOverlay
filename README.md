# iOSTutorialOverlay
Tutorials are super useful the first time a user runs your iOS app. With JNTutorialOverlays, add tutorial overlays simply and efficiently to your project!
The overlays are only shown one time: Once the user has tapped it it doesn't come back!

#Install
Import JNTutorialOverlay.swift in your project. Use at will!

#Use
```swift
let tutorialOverlay = JNTutorialOverlay(overlayName: "Whatever", width: 300, height: 300, opacity: 0.8, title: "My first tutorial", message: "This is the default overlay")
```

#Configuration
There are 4 different ways to init a JNTutorialOverlay:
- Init with a defined width and height, with or without a picture
- Init with a custom CGRect frame, with or without a picture

Once an overlay is created, it can be modified as such:
```swift
let tutorialOverlay = JNTutorialOverlay(overlayName: "Whatever", width: 300, height: 300, opacity: 0.8, title: "My first tutorial", message: "This is the default overlay")
tutorialOverlay.theme = .Light // Possible values are .Light and .Dark (default)
tutorialOverlay.corners = .Straight // Possible values are .Straight and .Rounded (default)
tutorialOverlay.title = "Title"
tutorialOverlay.message = "Message"
tutorialOverlay.image = UIImage(named: "yourPictureName")
```

[Download Birdcast on iOS to see overlays in action](https://itunes.apple.com/us/app/birdcast-rapid-tweeting-for/id966526563?ls=1&mt=8)