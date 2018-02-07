//
//  ObjectModelNode.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 06/02/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import SceneKit.ModelIO

class ObjectModelNode: SCNNode {
    
    override init() {
        super.init()
        
        //Load .obj
        guard let url = Bundle.main.url(forResource: "CenterTable", withExtension: "obj") else {
            fatalError("Failed to find model file.")
        }

        let asset = MDLAsset(url:url)
        guard let object = asset.object(at: 0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        
        //Texture
//        let scatteringFunction = MDLPhysicallyPlausibleScatteringFunction()
        
//        let material = MDLMaterial(name: "baseMaterial", scatteringFunction: scatteringFunction)
        
//        material.setTextureProperties(textures: [ //MDLMaterialSemantic key.value array
//            .baseColor:"default-wood.jpg"])
        
//        for  submesh in object.submeshes!  {
//            if let submesh = submesh as? MDLSubmesh {
//                submesh.material = material
//            }
//        }
        
        let node = SCNNode(mdlObject: object)
        node.name = name
        
        self.addChildNode(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//To set exposure key/value properties
extension MDLMaterial {
    func setTextureProperties(textures: [MDLMaterialSemantic:String]) -> Void {
        for (key,value) in textures {
            guard let url = Bundle.main.url(forResource: value, withExtension: "") else {
                fatalError("Failed to find URL for resource \(value).")
            }
            let property = MDLMaterialProperty(name:value, semantic: key, url: url)
            self.setProperty(property)
        }
    }
}
