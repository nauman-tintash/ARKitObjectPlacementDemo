//
//  ViewController.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 30/01/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import FileExplorer

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    // MARK: - Attributes
    var objectModelScene: ObjectModelScene!
    var fileExplorerViewController: FileExplorerViewController!
    
    var currentlySelectedModelURL: URL?
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the file explorer view controller
        initializeFileExplorerView()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        shipScene = SCNScene(named: "art.scnassets/ship.scn")!
        
        currentlySelectedModelURL = URL.documentDirectory
        
        objectModelScene = ObjectModelScene()
        
        objectModelScene.hide()
        
        // Set the scene to the view
        sceneView.scene = objectModelScene
        
        //Set the environment attributes
        sceneView.autoenablesDefaultLighting = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startNewSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    /// - Tag: PlaceARContent
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         `SCNPlane` is vertically oriented in its local coordinate space, so
         rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
         */
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0.25
        
        /*
         Add the plane visualization to the ARKit-managed node so that it tracks
         changes in the plane anchor as plane estimation continues.
         */
        node.addChildNode(planeNode)
    }
    
    /// - Tag: UpdateARContent
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        // Update content only for plane anchors and nodes matching the setup created in `renderer(_:didAdd:for:)`.
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        
        // Plane estimation may shift the center of a plane relative to its anchor's transform.
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        /*
         Plane estimation may extend the size of the plane, or combine previously detected
         planes into a larger one. In the latter case, `ARSCNView` automatically deletes the
         corresponding node for one plane, then calls this method to update the size of
         the remaining plane.
         */
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
    }
    
    //MARK: Update at interval
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate
        
        if (lightEstimate != nil) {
            print (lightEstimate?.ambientIntensity)
            // Here you can now change the .intensity property of your lights
            // so they respond to the real world environment
            objectModelScene.setLightIntensity(lightIntensity: (lightEstimate?.ambientIntensity)!)
        }
    }
    
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        guard let frame = session.currentFrame else { return }
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        startNewSession()
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        sessionInfoLabel.text = "Session interruption ended"
        startNewSession()
    }
    
    // MARK: - Gesture Recognizers
    
    @IBAction func didTap(_ recognizer: UITapGestureRecognizer) {
        
        let location = recognizer.location(in: sceneView)
        
        // When tapped on a plane, reposition the content
        let arHitTestResult = sceneView.hitTest(location, types: .existingPlane)
        if !arHitTestResult.isEmpty {
            let hit = arHitTestResult.first!
            
            objectModelScene.show()
            objectModelScene.setTransform(hit.worldTransform)
        }
    }
    
    @IBAction func didPan(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: sceneView)
        
        // Drag the object on an infinite plane
        let arHitTestResult = sceneView.hitTest(location, types: .existingPlane)
        if !arHitTestResult.isEmpty {
            let hit = arHitTestResult.first!
            objectModelScene.setTransform(hit.worldTransform)
        }
    }
    
    // MARK: - Private Functions.
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move the device around to detect horizontal surfaces."
            
        case .normal:
            // No feedback needed when tracking is normal and planes are visible.
            message = ""
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }
    
    //Start a new session after resettng tracking and removing existing anchors.
    private func startNewSession() {
        // Create a session configuration with horizontal plane detection
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        
        // Run the view's session
        sceneView.session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }

    @IBAction func chooseModelCallback(_ sender: Any) {
        self.present(fileExplorerViewController, animated: true, completion: nil)
    }
}
