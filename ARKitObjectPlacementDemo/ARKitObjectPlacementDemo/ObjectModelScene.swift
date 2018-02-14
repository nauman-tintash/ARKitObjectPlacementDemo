//
//  ObjectModelScene.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 01/02/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

public enum ModelType{
    case kGLTF
    case kOBJ
}

class ObjectModelScene: SCNScene {
    
    // Special nodes used to control animations of the model
    private let contentRootNode = SCNNode()
    private var geometryRoot: SCNNode!
    
    private var wrapperNode: SCNNode!
    
    // State variables
    private var modelLoaded: Bool = false
    
    // MARK: - Initialization and Loading
    
    override init() {
        super.init()
        
        //TODO: Load the environment map
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadModel(objectModelURL: URL) {
        wrapperNode?.removeFromParentNode()
        
        if !objectModelURL.absoluteString.isEmpty && objectModelURL.isFileURL {
        
            let modelType = objectModelURL.absoluteString.hasSuffix(".obj") ? ModelType.kOBJ : ModelType.kGLTF
            
            switch modelType {
            case .kOBJ:
                wrapperNode = ObjectModelNode(objectModelURL: objectModelURL)
                
                self.rootNode.addChildNode(contentRootNode)
                contentRootNode.addChildNode(wrapperNode)
                break
            case .kGLTF:
                wrapperNode = ObjectModelNodeGLTF(objectModelURL: objectModelURL)
                
                self.rootNode.addChildNode(contentRootNode)
                contentRootNode.addChildNode(wrapperNode)
                break
            }
            
    //        hide()
            
            setupShader()
            resetState()
            
            modelLoaded = true
        }
    }
    
    // MARK: - Public API
    
    func show() {
        contentRootNode.isHidden = false
    }
    
    func hide() {
        contentRootNode.isHidden = true
        resetState()
    }
    
    func isVisible() -> Bool {
        return !contentRootNode.isHidden
    }
    
    func setTransform(_ transform: simd_float4x4) {
        contentRootNode.simdTransform = transform
    }
}

// MARK: - React To Rendering

extension ObjectModelScene {
    
    func reactToRendering(in sceneView: ARSCNView) {
        // Update environment map to match ambient light level
        lightingEnvironment.intensity = (sceneView.session.currentFrame?.lightEstimate?.ambientIntensity ?? 1000) / 100
    }
}

// MARK: - Helper functions

extension ObjectModelScene {
    
    private func resetState() {
        //Reset the state of the model here.
    }
    
    private func setupShader() {
        //Setup shaders for the model here.
    }
}
