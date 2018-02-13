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
    
    init(objectModelName: String) {
        super.init()
        
        //Load .obj
        guard let url = Bundle.main.url(forResource: "Models/" + objectModelName + "/obj/scene", withExtension: "obj") else {
            fatalError("Failed to find model file.")
        }

        let asset = MDLAsset(url:url)
        guard let object = asset.object(at: 0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        
        do {
            if let file = Bundle.main.url(forResource: "Models/" + objectModelName + "/obj/modelinfo", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])

                if let dictionary = json as? [String: Any] {
                    if let materials = dictionary["materials"] as? [String: Any] {
                        // access individual value in dictionary

                        for  submesh in object.submeshes!  {
                            if let submesh = submesh as? MDLSubmesh {
                                let materialName = submesh.material?.name

                                if let materialJSON = materials[materialName!] as? [String: Any] {

                                    let metalnessValueString = materialJSON["metalnessValue"] as? String
                                    let roughnessValueString = materialJSON["roughnessValue"] as? String
                                    let metalnessMap = materialJSON["metalnessMap"] as? String
                                    let roughnessMap = materialJSON["roughnessMap"] as? String

                                    let metalnessValue = (NSString(string: metalnessValueString!)).floatValue
                                    let roughnessValue = (NSString(string: roughnessValueString!)).floatValue

                                    //Texture
                                    let material = submesh.material

                                    if (metalnessMap?.isEmpty)!{
                                        material?.setTextureProperties(textures: [//[MDLMaterialSemantic : Float]
                                            MDLMaterialSemantic.metallic: metalnessValue,
                                            MDLMaterialSemantic.roughness: roughnessValue
                                            ]
                                        )
                                    } else {
                                        material?.setTextureProperties(textures: [//[MDLMaterialSemantic : String]
                                            MDLMaterialSemantic.metallic: metalnessMap!,
                                            MDLMaterialSemantic.roughness: roughnessMap!
                                            ]
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
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
    
    func setTextureProperties(textures: [MDLMaterialSemantic:Float]) -> Void {
        for (key,value) in textures {
            let property = MDLMaterialProperty(name: String(value), semantic: key, float: value)

            self.setProperty(property)
        }
    }
}
