//
//  ViewController.swift
//  PhoneNumber
//
//  Created by Ульяна Гритчина on 19.11.2022.
//

import UIKit

class MobileNumberViewController: UIViewController {
    
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    private let regex = try! NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mobileNumberTF.delegate = self
        setupToolBar()
    }
    
    private func format(number: String, shudeRemoveLastDegit: Bool) -> String {
        var mobileNumber = number // Ввела новую переменную, чтобы можно было удалять символы
        var finalString = ""
        
        // Из видоса swiftbook
        guard !(shudeRemoveLastDegit && number.count <= 2) else { return "" }
        let range = NSString(string: number).range(of: number)
        var newNumber = regex.stringByReplacingMatches(in: number, range: range, withTemplate: "")
        
        if newNumber.count > 11 {
            let maxIndex = newNumber.index(newNumber.startIndex, offsetBy: 11)
            newNumber = String(newNumber[newNumber.startIndex..<maxIndex])
        }
        
        if shudeRemoveLastDegit {
            let maxIndex = newNumber.index(newNumber.startIndex, offsetBy: newNumber.count - 1)
            newNumber = String(newNumber[newNumber.startIndex..<maxIndex])
        }
        
        let maxIndex = newNumber.index(newNumber.startIndex, offsetBy: newNumber.count)
        let regRange = number.startIndex..<maxIndex
        
        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            newNumber = newNumber.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
            finalString = ""
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            newNumber = newNumber.replacingOccurrences(of: pattern, with: "$1 ($2) $3-$4-$5", options: .regularExpression, range: regRange)
            finalString = ""
        }
        
        
        // Автозамена. Скорее всего можно сделать лучше
        if number.first != "7" && number.first != "8" && number.first != "+" {
            finalString = "+7" + newNumber
            
        } else if number.first == "8" {
            
            mobileNumber = String(mobileNumber.dropFirst()) // Удаляем восьмерку
            finalString = "+7" + mobileNumber
            
        } else {
            finalString = "+" + newNumber
        }
        
        return finalString
    }
    
    private func setupToolBar() {
        let bar = UIToolbar()
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        let done = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(done)
        )
        bar.items = [spacer, done]
        bar.sizeToFit()
        mobileNumberTF.inputAccessoryView = bar
    }
    
    
    @objc private func done() {
        self.view.endEditing(true)
    }
    
}


//MARK: - TextFieldDelegate

extension MobileNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let fullString = (textField.text ?? "") + string
        textField.text = format(number: fullString, shudeRemoveLastDegit: range.length == 1)
        return false
    }
}
