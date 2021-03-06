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

### Create a scene class to create a scene for our model
- Implement the ObjectModelScene inherited from SCNScene as implemented in the demo.
- Modify the `loadModel` function and `setupShader()` functions to implement the respective features for your specific model.

### Place the object on a horizontal plane
- Add the tap, pan and rotate gestures to the storyboard.
- Implement the `didPan`, `didTap` and `didRotate` gestures in the UIViewController and set those as outlets for IBActions for didPan, didTap and didRotate.
- Use the impementation of `didPan`, `didTap` and `didRotate` from this demo to control the positioning of the model on horizontal surfaces.

### `loadModel` Funtion
We'll use this function to load the model node for our scene. Here we check for the extension of the model and decide whether to load a glTF node or OBJ node.

### Add the sample assets in the project
Create an Assets folder in the project and iside this, place all the assets in whatever dirrectory structure suits you.

For OBJ models, the assets should have an .obj, .mtl and any required maps files as well as a modelinfo.json file which should contain the roughness and metalness values. The glTF would require a glTF file and any separate maps being used.

Sample modelinfo.json:
```
{
    "materials": {
        "std_01___Default": {
            "metalnessValue": "0.3",
            "roughnessValue": "0.2775",
            "metalnessMap": "",
            "roughnessMap": ""
        },
        "std_02___Default": {
            "metalnessValue": "",
            "roughnessValue": "",
            "metalnessMap": "metalness_map_file.jpg",
            "roughnessMap": "roughness_map_file.jpg"
        }
    }
}
```

NOTE: Make sure there aren't any white spaces in any of the filenames as well as any of the material IDs.

NOTE: Make sure all the material IDs in the modelinfo.json correspond to respective material names in the .mtl file.

### Implement the ObjectModelNode class
Implement the ObjectModelNode class to handle the loading of models and textures for a model.

In order to load the model, just load the .obj file. That would load the mesh and also apply the respective materials from the .mtl file.
Afterwards, simply parse the modelinfo.json file to extract extra features like metalness and roughness and apply those to respective submeshes using the `SCNMaterial` class.

### Add Lights to the scene
- Implement the insert spot light function as done in the demo to add a spot light to the scene if you want.
- With PBR it is recommended to add environment maps instead of spot light. In order to do that, set the contents of environment map to an image and disable the spotlight.

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
