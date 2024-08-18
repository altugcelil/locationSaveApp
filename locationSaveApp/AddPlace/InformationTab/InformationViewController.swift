//
//  InformationViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

class InformationViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: CustomTextField!
    let placeHolderText = "Örn: Güzel kahveleri var, hızlı internet ve sakin bir ortam."
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        self.hideKeyboardWhenTappedAround()
        setupTextFields()
    }
    
    private func setupTextFields() {
        noteTextView.text = placeHolderText
        noteTextView.textColor = UIColor.lightGray
        noteTextView.delegate = self
        
        titleTextField.staticPlaceholderText = "Bu yer için isim giriniz: "
        titleTextField.placeholder = "Örn: Butik Kafe (Acıbadem) "
        titleTextField.textColor = .black
        titleTextField.delegate = self
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textViewHeight.constant = size.height
        view.layoutIfNeeded()
    }
}
