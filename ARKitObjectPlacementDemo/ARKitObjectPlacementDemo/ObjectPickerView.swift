//
//  ObjectPickerView.swift
//  ARKitObjectPlacementDemo
//
//  Created by Nauman on 09/02/2018.
//  Copyright © 2018 Nauman. All rights reserved.
//

import Foundation
import UIKit

extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
        currentlySelectedModelIndex = row
        
        objectModelScene.loadModel(objectModelName: pickerData[currentlySelectedModelIndex!], modelType: currentlySelectedModelType!)
    }
    
    @IBAction func ObjectPickerValueChanged(_ sender: Any) {
        if currentlySelectedModelType == ModelType.kGLTF {
            currentlySelectedModelType = ModelType.kOBJ
        } else if currentlySelectedModelType == ModelType.kOBJ {
            currentlySelectedModelType = ModelType.kGLTF
        }
        
        objectModelScene.loadModel(objectModelName: pickerData[currentlySelectedModelIndex!], modelType: currentlySelectedModelType!)
    }
}
