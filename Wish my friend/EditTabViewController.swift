//
//  EditTabViewController.swift
//  Good Friend
//
//  Created by Sarath Chandra Damineni on 11/03/2021.
//

import UIKit

class EditTabViewController: UIViewController {

    @IBOutlet weak var timepick: UIDatePicker!
    @IBOutlet weak var nameSave: UIButton!
    @IBOutlet weak var name_text: UITextField!
    @IBOutlet weak var nameTextIndicator: UILabel!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        var savedName: String = (defaults.string(forKey: "Name")) ?? "NaN"
        name_text.text = (defaults.string(forKey: "Name")) ?? "NaN"
        timepick.datePickerMode = .time

        if(defaults.string(forKey: "Name") != "NaN")
        {
            nameTextIndicator.text = "Your name is saved as \(savedName)"
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapScreen(_:)))
            self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapScreen(_ sender: UITapGestureRecognizer)
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    @IBAction func saveNowPressed(_ sender: Any)
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        let newName:String = name_text.text ?? "0"
        nameTextIndicator.text = "Your name is saved as \(newName)"

        defaults.set(newName, forKey:"Name")

    }
    
    @IBAction func notificationSwitchAction(_ sender: Any)
    {
        //the status of the switch is after the toggle
        if(notificationSwitch.isOn)
        {

            print("notification switch off to on")
        }
        else
        {
            //notification switch from on to off
            print("notification switch from on to off")
        }
    }
}


