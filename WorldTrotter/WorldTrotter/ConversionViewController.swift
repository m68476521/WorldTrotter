//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Miguel Orozco on 12/30/18.
//  Copyright © 2018 m68476521. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var celsiusLabel: UILabel!
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
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
        print("ConvertionViewController loaded its view")
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
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celciusValue.value))
        } else {
            celsiusLabel.text = "???"
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.")
        let replacementStringCharacterSet = CharacterSet(charactersIn: string)
        if !replacementStringCharacterSet.isSubset(of: allowedCharacterSet) {
            print("Rejected (Invalid Character)")
            return false
        }
        
        if existingTextHasDecimalSeparator != nil,
            replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let calendar = Calendar(identifier: Calendar.Identifier.iso8601)
        let currentHour = calendar.component(.hour, from: Date())
        
        var randomFloat: CGFloat {
            get {
                return CGFloat(arc4random())
            }
        }
        
        let darkColor = UIColor(red: 13/255.0, green: 61/255.0, blue: 91/255.0, alpha: 1.0)
        let morningColor = UIColor(red: 250/255.0, green: 150/255.0, blue: 12/255.0, alpha: 0.6)
        let noonColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 150/255.0, alpha: 1.0)
        let duskColor = UIColor(red: randomFloat, green: randomFloat, blue: randomFloat, alpha: 0.6)
        
        switch currentHour {
        case 7...10:
            view.backgroundColor = morningColor
        case 11...14:
            view.backgroundColor = noonColor
        case 15...19:
            view.backgroundColor = duskColor
        default:
            view.backgroundColor = darkColor
        }
    }
}
