# Placing 3D objects in ARKit

## What this sample demonstrates
This sample demonstrates using SceneKit and ARKit to place 3D models in an augmented reality environment.

It uses ARKit to detect a horizontal plane and then based on user input, it places a 3D model in the environment.

## Implementation Details

### Set up the project environment
Create a new ARKit project with SceneKit being the rendering platform. Run the project and verify that you can see an AR environment with a ship model in front of the camera's starting position and orientation.

### Update UIViewController's storyboard to add the AR scene in a UIView.
- In the Main.Storyboard, add a UIView and then we'll add all the UI components and scene inside this UIView. For now, only add the ARSCNView inside the UIView.
- After adding the view, set the constraints of UIView and ARSCNView so that they cover the whole screen or the desired portion of the screen you want to show AR scene in.

### Update UIViewController's storyboard to add a Session Info Label
Update UIViewController's storyboard to add a label in the UIView and set its constraints so that it is in some corner of the screen.

### Set the outlets for some UI elements
Add IBOutlets for ARSCNScene, Session Info View and the label for session info.

### Update UIViewController to implement ARSCNViewDelegate and ARSessionDelegate
- Set the session delegate to self. Note that scene delegate is already being set in the default starting project in viewDidLoad. `sceneView.session.delegate = self`
- Implement the `updateSessionInfoLabel` as private function as implemented in this demo.
- Implement the `startNewSession` as private function as implemented in this demo.
- Implement the functions to implement ARSCNViewDelegate and ARSessionDelegate as implemented in this demo.

### Placing the object on a horizontal plane


## Useful Resources

* [ARKit Framework](https://developer.apple.com/documentation/arkit)

* [WWDC 2017 - Session 602, Introducing ARKit: Augmented Reality for iOS ](https://developer.apple.com/videos/play/wwdc2017/602/)

## Requirements
### Running the sample

* For plane detection to work, you will need to view a flat and sufficiently textured surface through the on device camera while this sample is running.

### Build

Xcode 9 and iOS 11 SDK

### Runtime

iOS 11 or later

ARKit requires an iOS device with an A9 or later processor.

## References

* [ARKit Framework](https://developer.apple.com/documentation/arkit)
* [Building Your First AR Experience](https://developer.apple.com/documentation/arkit/building_your_first_ar_experience)
* [Interactive Content with ARKit](https://developer.apple.com/library/content/samplecode/InteractiveContent/Introduction/Intro.html)
