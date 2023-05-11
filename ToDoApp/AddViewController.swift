//
//  AddViewController.swift
//  ToDoApp
//
//  Created by Benazir Toleubekova on 09.05.2023.
//

import UIKit

class AddViewController: ViewController {
        
    lazy var textFieldView: UITextField = {
    let textField =  UITextField()
    textField.placeholder = "Название"
    textField.backgroundColor = UIColor.white
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
    textField.leftViewMode = .always
    textField.clipsToBounds = true
    textField.layer.cornerRadius = 6
    textField.layer.shadowRadius = 2
    textField.layer.borderWidth = 1
    textField.becomeFirstResponder()
            
    view.addSubview(textField)
            
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.right.left.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }

            
            return textField
        }()
        
    lazy var textViewDescription: UITextView = {
    let textView = UITextView()
    textView.text = "Описание"
    textView.font = .systemFont(ofSize: 18)
    textView.textColor = .systemGray3
    textView.clipsToBounds = true
    textView.layer.cornerRadius = 6
    textView.layer.shadowRadius = 2
    textView.layer.borderWidth = 1
    textView.resignFirstResponder()
            
    textView.delegate = self
            
    view.addSubview(textView)
            
        
        textView.snp.makeConstraints { make in
        make.top.equalTo(textFieldView.snp.top).inset(90)
        make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        make.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

            return textView
        }()
        
    
    private lazy var listLayoutViews = [textFieldView, textViewDescription]
        
       
    override func viewDidLoad() {
           super.viewDidLoad()
            
    view.backgroundColor = .systemGray6
            
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: #selector(saveButton))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButton))
            navigationItem.leftBarButtonItem?.tintColor = .systemRed
            
    let _ = listLayoutViews.compactMap { $0 }
        
        }
        
        
    @objc private func saveButton() {
        let nameTextFieldSent = textFieldView.text
        let descriptionTextViewSent = textViewDescription.text
            
        let dictionaryTextSent = [nameTextFieldSent: descriptionTextViewSent]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Add"), object: dictionaryTextSent)
            
        dismiss(animated: true, completion: nil)
        }
        
        @objc private func cancelButton() {
            dismiss(animated: true, completion: nil)
        }
    }
    

    extension AddViewController: UITextViewDelegate {

        func textViewDidBeginEditing(_ textView: UITextView) {
    if textViewDescription.textColor == .systemGray3 {
        textViewDescription.text = ""
        textViewDescription.textColor = .black
    }
}

        func textViewDidEndEditing(_ textView: UITextView) {
    if textViewDescription.text == "" {
        textViewDescription.text = "Описание"
        textViewDescription.textColor = .systemGray3 
    }
        }
}

