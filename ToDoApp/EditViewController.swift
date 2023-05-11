//
//  EditViewController.swift
//  ToDoApp
//
//  Created by Benazir Toleubekova on 09.05.2023.
//

import UIKit

class EditViewController: AddViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // override only rightbarbutton for change title and action
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Изменить", style: .done, target: self, action: #selector(editButton))
    }
    
   
    @objc func editButton() {
        
        let nameTextFieldSent = textFieldView.text
        let descriptionTextViewSent = textViewDescription.text
        
        
        let dictionaryTextSent = [nameTextFieldSent: descriptionTextViewSent]
       
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Edit"), object: dictionaryTextSent)
        
    
        dismiss(animated: true, completion: nil)
    }
}

