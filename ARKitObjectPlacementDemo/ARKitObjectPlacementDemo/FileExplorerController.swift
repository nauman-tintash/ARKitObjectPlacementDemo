//
//  ObjectPickerView.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 09/02/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import Foundation
import UIKit
import FileExplorer

extension ViewController : FileExplorerViewControllerDelegate{
    
    func initializeFileExplorerView() {
        //Set the path of models directory
        let appPath = Bundle.main.resourceURL
        let modelsDirectoryPath = appPath?.appendingPathComponent("Models")
        
        //Initialize the view controller and set the delegate.
        fileExplorerViewController = FileExplorerViewController(directoryURL: modelsDirectoryPath!, providers: [])
        fileExplorerViewController.delegate = self
        
        fileExplorerViewController.canChooseFiles = true //specify whether user is allowed to choose files
        fileExplorerViewController.canChooseDirectories = false //specify whether user is allowed to choose directories
        fileExplorerViewController.allowsMultipleSelection = false //specify whether user is allowed to choose multiple files and/or directories
        
        fileExplorerViewController.selectableFileExtension = ["obj", "gltf"]
    }
    
    //MARK: - File explorer view delegate functions
    func fileExplorerViewControllerDidFinish(_ controller: FileExplorerViewController) {
        objectModelScene.hide()
    }
    
    func fileExplorerViewController(_ controller: FileExplorerViewController, didChooseURLs urls: [URL]) {
        currentlySelectedModelURL = urls[0]
        
        objectModelScene.loadModel(objectModelURL: currentlySelectedModelURL!)
    }
    
}
