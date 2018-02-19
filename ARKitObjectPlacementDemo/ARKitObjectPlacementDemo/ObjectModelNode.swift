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
import GLTFSceneKit

class ObjectModelNode: SCNNode {
    
    //TODO: Refactor this function into a bit more organised form.
    init(objectModelURL: URL) {
        super.init()
        
        do {
            let modelType = objectModelURL.absoluteString.hasSuffix(".obj") ? ModelType.kOBJ : ModelType.kGLTF
            
            var loadedScene:SCNScene
            
            if modelType == ModelType.kGLTF {
                let sceneSource = GLTFSceneSource(url: objectModelURL)
                loadedScene = try sceneSource.scene()
            } else {
                loadedScene = try SCNScene(url: objectModelURL, options: nil)
            }
            
            let rootNode = loadedScene.rootNode
            let childNodes = rootNode.childNodes
            
            switch modelType {
            case .kOBJ:
                loadMaterialInfoFromJSON(nodesList: childNodes, objectURL: objectModelURL)
                
                break
            case .kGLTF:
                for childNode in childNodes {
                    self.addChildNode(childNode)
                }
                break
            }
        } catch {
            print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadMaterialInfoFromJSON(nodesList: [SCNNode], objectURL: URL) {
        
        do {
            var modelInfoString = objectURL.deletingLastPathComponent().absoluteString
            modelInfoString = modelInfoString + "modelinfo.json"
            let jsonFile = URL(string: modelInfoString)
            
            let jsonData = try Data(contentsOf: jsonFile!)
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let dictionary = jsonObject as? [String: Any] {
                if let materialsDictionary = dictionary["materials"] as? [String: Any] {
                    
                    for childNode in nodesList {
                        let materialsInNode = childNode.geometry?.materials
                        
                        for materialObject in materialsInNode! {
                            materialObject.lightingModel = SCNMaterial.LightingModel.physicallyBased
                            
                            let materialName = materialObject.name
                            
                            print("DEBUG: Material Name : " + materialName!)
                            
                            if let materialJSON = materialsDictionary[materialName!] as? [String: Any] {
                                
                                let metalnessValueString = materialJSON["metalnessValue"] as? String
                                let roughnessValueString = materialJSON["roughnessValue"] as? String
                                let metalnessMap = materialJSON["metalnessMap"] as? String
                                let roughnessMap = materialJSON["roughnessMap"] as? String
                                
                                let metalnessValue = (NSString(string: metalnessValueString!)).floatValue
                                let roughnessValue = (NSString(string: roughnessValueString!)).floatValue
                                
                                //Texture
                                if (metalnessMap != ""){
                                    var roughnessMapString = objectURL.deletingLastPathComponent().absoluteString
                                    roughnessMapString = roughnessMapString + roughnessMap!
                                    let roughnessMapURL = URL(string: roughnessMapString)
                                    
                                    let imageData = try Data(contentsOf: roughnessMapURL!)
                                    materialObject.roughness.contents = UIImage(data: imageData)
                                    
                                    var metalnessMapString = objectURL.deletingLastPathComponent().absoluteString
                                    metalnessMapString = metalnessMapString + metalnessMap!
                                    let metalnessMapURL = URL(string: metalnessMapString)
                                    
                                    let imageDataMetalness = try Data(contentsOf: metalnessMapURL!)
                                    materialObject.metalness.contents = UIImage(data: imageDataMetalness)
                                } else {
                                    materialObject.roughness.contents = CGFloat(roughnessValue)
                                    materialObject.metalness.contents = CGFloat(metalnessValue)
                                }
                            }
                        }
                        
                        self.addChildNode(childNode)
                    }
                }
            }
        } catch {
            print(error)
        }
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
