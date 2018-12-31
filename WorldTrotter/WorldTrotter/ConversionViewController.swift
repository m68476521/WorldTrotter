//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Miguel Orozco on 12/30/18.
//  Copyright © 2018 m68476521. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    @IBOutlet var celsiusLabel: UILabel!
    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    @IBOutlet var textFiled: UITextField!
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
        } else {
            fahrenheitValue = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
    }
    
    @IBAction func dissmissKeyboard(_ sender: UITapGestureRecognizer) {
        textFiled.resignFirstResponder()
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheitValue = fahrenheitValue {
            return fahrenheitValue.converted(to: .celsius)
        } else {
            return nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celciusValue = celsiusValue {
            print(celciusValue.value)
            celsiusLabel.text = "\(celciusValue.value)"
        } else {
            celsiusLabel.text = "???"
        }
    }
}
