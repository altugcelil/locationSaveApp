//
//  EditPlaceViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 30.11.2024.
//


import UIKit
import CoreData
import Photos
import TOCropViewController

class EditPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = UIColor.systemBlue
      //  button.setTitle(NSLocalizedString("back_text", comment: ""), for: .normal)
        return button
    }()
    
    private let titleTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.staticPlaceholderText = NSLocalizedString("title_placeholder", comment: "")
        textField.staticPlaceholderFont = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 12), to: 12)
        return textField
    }()
    
    private let cityOrCountryField: CustomTextField = {
        let textField = CustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.staticPlaceholderText = NSLocalizedString("city_or_country_placeholder", comment: "")
        textField.staticPlaceholderFont = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 12), to: 12)
        return textField
    }()
    
    private let categoryContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let categoryHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("category_header_text", comment: "")
        label.font = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 12), to: 12)
        return label
    }()
    
    private let categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkModeWhite
        view.layer.cornerRadius = 8
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor
        return view
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("category_header", comment: "")
        label.font = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 14), to: 14)
        return label
    }()
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let noteHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("note_header_text", comment: "")
        label.font = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 12), to: 12)
        return label
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 14), to: 14)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.backgroundColor = .darkModeWhite
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.textColor = .lightGray
        return textView
    }()
    
    private let photoHeaderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("photos_header_text", comment: "")
        label.font = BaseFont.adjustFontSize(of: UIFont.systemFont(ofSize: 12), to: 12)
        return label
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo.badge.plus")
        imageView.tintColor = .darkModeBlack
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let ratingView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("save_changes", comment: ""), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    var place: Place?
    
    private lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate bulunamadı")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    private let placeHolderText = NSLocalizedString("note_placeholder", comment: "")
    
    private var textViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        loadPlaceData()
        setupActions()
    }
    
    private func setupUI() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .darkModeWhite
        title = NSLocalizedString("edit_place_title", comment: "")
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [backButton, titleTextField, cityOrCountryField, categoryContainerView, noteHeaderLabel, noteTextView,
         photoHeaderLabel, photoImageView, ratingView, saveButton].forEach {
            contentView.addSubview($0)
        }
        
        categoryContainerView.addSubview(categoryHeaderLabel)
        categoryContainerView.addSubview(categoryView)
        categoryView.addSubview(categoryLabel)
        categoryView.addSubview(chevronImageView)
        
        ratingView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryViewTapped))
        categoryView.addGestureRecognizer(tapGesture)
        categoryView.isUserInteractionEnabled = true
        
        noteTextView.delegate = self
        if noteTextView.text.isEmpty {
            noteTextView.text = placeHolderText
        }
        
        let addPhotoTapGesture = UITapGestureRecognizer(target: self, action: #selector(photoImageViewTapped))
        photoImageView.addGestureRecognizer(addPhotoTapGesture)
    }
    
    private func setupConstraints() {
        textViewHeight = noteTextView.heightAnchor.constraint(equalToConstant: 100)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleTextField.topAnchor.constraint(equalTo: backButton.topAnchor, constant: 64),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 50),
            
            cityOrCountryField.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 32),
            cityOrCountryField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityOrCountryField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cityOrCountryField.heightAnchor.constraint(equalToConstant: 50),
            
            categoryContainerView.topAnchor.constraint(equalTo: cityOrCountryField.bottomAnchor, constant: 32),
            categoryContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            categoryHeaderLabel.topAnchor.constraint(equalTo: categoryContainerView.topAnchor),
            categoryHeaderLabel.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor),
            
            categoryView.topAnchor.constraint(equalTo: categoryHeaderLabel.bottomAnchor, constant: 8),
            categoryView.leadingAnchor.constraint(equalTo: categoryContainerView.leadingAnchor),
            categoryView.trailingAnchor.constraint(equalTo: categoryContainerView.trailingAnchor),
            categoryView.heightAnchor.constraint(equalToConstant: 50),
            categoryView.bottomAnchor.constraint(equalTo: categoryContainerView.bottomAnchor),
            
            categoryLabel.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -8),
            
            chevronImageView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor),
            chevronImageView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor, constant: -16),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            noteHeaderLabel.topAnchor.constraint(equalTo: categoryContainerView.bottomAnchor, constant: 16),
            noteHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            noteTextView.topAnchor.constraint(equalTo: noteHeaderLabel.bottomAnchor, constant: 8),
            noteTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            noteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textViewHeight,
            
            photoHeaderLabel.topAnchor.constraint(equalTo: noteTextView.bottomAnchor, constant: 16),
            photoHeaderLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            photoImageView.topAnchor.constraint(equalTo: photoHeaderLabel.bottomAnchor, constant: 8),
            photoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: 300),
            photoImageView.heightAnchor.constraint(equalToConstant: 300),
            
            ratingView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 16),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            ratingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            ratingView.heightAnchor.constraint(equalToConstant: 44),
            
            saveButton.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 24),
            saveButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupActions() {
        saveButton.addTarget(self, action: #selector(saveChangesButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    }
    
    @objc private func didTapBackButton() {
        self.dismiss(animated: true)
    }
    
    private func loadPlaceData() {
        guard let place = place else { return }
        
        titleTextField.text = place.title
        cityOrCountryField.text = place.cityOrCountry
        categoryLabel.text = place.categoryName
        if let note = place.note, !note.isEmpty {
            noteTextView.text = note
            noteTextView.textColor = UIColor(named: "DarkModeBlack")
        } else {
            noteTextView.text = placeHolderText
            noteTextView.textColor = .lightGray
        }

    ratingView.rating = place.rating    
        if let imageData = place.imageData {
            photoImageView.image = UIImage(data: imageData)
        } else {
            photoImageView.image = UIImage(systemName: "photo.badge.plus")
        }
    }
    
    @objc private func categoryViewTapped() {
        let categoryVC = DropdownSelectionViewController(nibName: "DropdownSelection", bundle: nil)
        categoryVC.searchViewModel = DropdownModel.Category
        categoryVC.dropdownSelectionViewControllerDelegate = self
        categoryVC.modalPresentationStyle = .pageSheet
        present(categoryVC, animated: true)
    }
    
    @objc private func saveChangesButtonTapped() {
        guard let place = place else { return }
        
        place.title = titleTextField.text
        place.cityOrCountry = cityOrCountryField.text
        place.categoryName = categoryLabel.text
        place.note = noteTextView.text
        place.rating = ratingView.rating
        
        if let image = photoImageView.image, image != UIImage(systemName: "photo.badge.plus") {
            place.imageData = image.jpegData(compressionQuality: 0.7)
        }
        
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("PlaceEdited"), object: nil)
            showAlert(title: "", message: NSLocalizedString("edit_success", comment: "")) {
                self.dismiss(animated: true)
            }
        } catch {
            showAlert(title: "Error", message: NSLocalizedString("edit_error", comment: ""))
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok_text", comment: ""), style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    @objc private func photoImageViewTapped() {
        let alert = UIAlertController(title: NSLocalizedString("select_photo", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("take_photo", comment: ""), style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("choose_from_gallery", comment: ""), style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = photoImageView
            popoverController.sourceRect = photoImageView.bounds
            popoverController.permittedArrowDirections = .any
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func savePhoto(image: UIImage) {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            PlaceInfoModel.instance.photoData = imageData
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print(NSLocalizedString("camera_not_available", comment: ""))
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        picker.dismiss(animated: true) { [weak self] in
            DispatchQueue.main.async {
                self?.showCropViewController(image: selectedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(croppingStyle: .default, image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.resetAspectRatioEnabled = false
        cropViewController.modalPresentationStyle = .fullScreen
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        photoImageView.image = image
        photoImageView.contentMode = .scaleAspectFill
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true)
    }
}

extension EditPlaceViewController: RatingViewDelegate {
    func ratingView(_ ratingView: RatingView, didUpdateRating rating: Float) {
        // Rating değişikliği işleniyor
    }
}

extension EditPlaceViewController: DropdownSelectionViewControllerDelegate {
    func setSelected(item: DropdownControllerModel, searchViewModel: DropdownModel) {
        switch searchViewModel {
        case .Category:
            categoryLabel.text = item.name
        }
    }
}

extension EditPlaceViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = ""
            textView.textColor = UIColor(named: "DarkModeBlack")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        if size.height <= 100 {
            textViewHeight.constant = size.height
            view.layoutIfNeeded()
        }
    }
}
