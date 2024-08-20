//
//  InformationViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

protocol InformationViewControllerDelegate: AnyObject {
    func validationStateDidChange(isValid: Bool)
}

class InformationViewController: UIViewController, RatingViewDelegate {
    
    @IBOutlet weak var cityOrCountryField: CustomTextField!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var titleTextField: CustomTextField!
    let placeHolderText = "Örn: Güzel kahveleri var, hızlı internet ve sakin bir ortam."

    weak var delegate: InformationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        setupUI()
        let isTitleValid = titleTextField.text?.count ?? 0 > 1
        let isCityOrCountryValid = cityOrCountryField.text?.count ?? 0 > 1
        
        let isFormValid = isTitleValid && isCityOrCountryValid
        notifyValidationState(isValid: isFormValid)
    }
    
    private func setupUI() {
        self.hideKeyboardWhenTappedAround()
        ratingView.delegate = self
        setupTextFields()
    }
    
    private func setupTextFields() {
        noteTextView.text = placeHolderText
        noteTextView.textColor = UIColor.lightGray
        noteTextView.delegate = self
        
        titleTextField.staticPlaceholderText = "Bu yer için isim girin: "
        titleTextField.placeholder = "Örn: Butik Kafe (Acıbadem) "
        titleTextField.textColor = .black
        titleTextField.delegate = self
        
        cityOrCountryField.staticPlaceholderText = "Şehir veya ülke girin: "
        cityOrCountryField.placeholder = "Örn: İstanbul "
        cityOrCountryField.delegate = self
    }
    
    func ratingView(_ ratingView: RatingView, didUpdateRating rating: Float) {
        ratingLabel.text = "Puan: \(rating)"
        PlaceInfoModel.instance.rating = rating
      }
    
    private func notifyValidationState(isValid: Bool) {
        delegate?.validationStateDidChange(isValid: isValid)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
extension InformationViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return false }
        let newText = currentText.replacingCharacters(in: range, with: string)
        let isValid = newText.count > 1
        
        if textField == titleTextField {
            updatePlaceholder(for: titleTextField, isValid: isValid, validPlaceholder: "Bu yer için isim girin: ", invalidPlaceholder: "Lütfen geçerli bir isim girin.")
            PlaceInfoModel.instance.title = newText
        } else if textField == cityOrCountryField {
            updatePlaceholder(for: cityOrCountryField, isValid: isValid, validPlaceholder: "Şehir veya ülke girin: ", invalidPlaceholder: "Lütfen geçerli bir şehir/ülke girin.")
            PlaceInfoModel.instance.cityOrCountry = newText
        }
        validateForm()
        return true
    }
    
    private func updatePlaceholder(for textField: CustomTextField, isValid: Bool, validPlaceholder: String, invalidPlaceholder: String) {
        textField.staticPlaceholderText = isValid ? validPlaceholder : invalidPlaceholder
        textField.staticPlaceholderColor = isValid ? .blue : .red
    }
    
    private func validateForm() {
        let isTitleValid = titleTextField.text?.count ?? 0 > 1
        let isCityOrCountryValid = cityOrCountryField.text?.count ?? 0 > 1
        
        let isFormValid = isTitleValid && isCityOrCountryValid
        notifyValidationState(isValid: isFormValid)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension InformationViewController: UITextViewDelegate {
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
        }else {
            PlaceInfoModel.instance.note = textView.text
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textViewHeight.constant = size.height
        PlaceInfoModel.instance.note = textView.text
        view.layoutIfNeeded()
    }
}
