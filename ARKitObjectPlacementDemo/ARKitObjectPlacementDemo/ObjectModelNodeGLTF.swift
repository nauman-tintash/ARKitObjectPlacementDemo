//
//  ObjectModelNodeGLTF.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 09/02/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import GLTFSceneKit

class ObjectModelNodeGLTF: SCNNode {
    
    init(objectModelName: String) {
        super.init()
        
        var scene: SCNScene
        do {
            guard let url = Bundle.main.url(forResource: "Models/" + objectModelName + "/gltf/scene", withExtension: "gltf") else {
                fatalError("Failed to find model file.")
            }

            let sceneSource = GLTFSceneSource(url: url)
            scene = try sceneSource.scene()
            
        } catch {
            print("\(error.localizedDescription)")
            return
        }
        
        let node = scene.rootNode
//        node.scale = SCNVector3(0.1, 0.1, 0.1)
        
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


