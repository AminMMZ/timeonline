//
//  JobInspectorViewController.swift
//  TimeOnLine
//
//  Created by Amin on 1/30/19.
//  Copyright © 2019 Amin. All rights reserved.
//

import UIKit

class JobInspectorViewController: UIViewController {

    @IBOutlet weak var typeTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var durationTextField: UITextField!
    
    var editMode = false
    var mainViewController: MainViewController {
        return (navigationController?.viewControllers[0] as? MainViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.clipsToBounds = true
    }
    

    @IBAction func touchMiddleButton(_ sender: UIButton) {
        if editMode == false {
            mainViewController.onGoingJob = Job(type: typeTextField.text!, description: descriptionTextView.text!, start: Date(), duration: 0)
            navigationController?.popViewController(animated: true)
        } else {
            
        }
        
    }
    
    @IBAction func touchSaveButton(_ sender: UIButton) {
        if let duration = Int(durationTextField.text!) {
            mainViewController.jobs.append(Job(type: typeTextField.text!, description: descriptionTextView.text!, start: datePicker.date, duration: Double(duration)))
            navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func touchBackground(_ sender: Any)
    {
        view.endEditing(true)
    }
}
