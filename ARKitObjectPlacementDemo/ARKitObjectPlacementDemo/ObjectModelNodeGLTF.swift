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
    
    init(objectModelURL: URL) {
        super.init()
        
        var scene: SCNScene
        do {
            let sceneSource = GLTFSceneSource(url: objectModelURL)
            scene = try sceneSource.scene()
            
        } catch {
            print("\(error.localizedDescription)")
            return
        }
        
        let node = scene.rootNode
        
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


