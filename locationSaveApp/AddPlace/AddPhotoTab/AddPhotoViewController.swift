//
//  AddPhotoViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 19.08.2024.
//

import UIKit
import CoreData
import TOCropViewController

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TOCropViewControllerDelegate {
    @IBOutlet weak var addPhotoImageView: UIImageView!
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func saveLocation(name: String, latitude: Double, longitude: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let place = Place(context: context)
        place.title =  PlaceInfoModel.instance.title
        place.latitude = PlaceInfoModel.instance.latitude ?? 0
        place.longitude =  PlaceInfoModel.instance.longitude ?? 0
        place.note = PlaceInfoModel.instance.note
        place.rating = PlaceInfoModel.instance.rating ?? 0
        
        place.imageData =  PlaceInfoModel.instance.photoData
        do {
            try context.save()
        } catch {
            print("Failed to save location: \(error)")
        }
    }
    
    @IBAction func testButton(_ sender: UIButton) {
        saveLocation(name: "", latitude: 41.2, longitude: 40.2)
    }
    
    @IBAction func addPhotoClicked(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func savePhoto(image: UIImage) {
        // UIImage'yi Data türüne dönüştür
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            // Data'yı placeInfo nesnesine ata
            PlaceInfoModel.instance.photoData = imageData
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.showsCameraControls = false
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
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
        picker.dismiss(animated: true, completion: nil)
        
        if let selectedImage = info[.originalImage] as? UIImage {
            addPhotoImageView.image = selectedImage
            showCropViewController(image: selectedImage)
        }
    }
    func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioPreset = .presetSquare
        cropViewController.aspectRatioLockEnabled = true
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        addPhotoImageView.image = image
        savePhoto(image: image)
        cropViewController.dismiss(animated: true, completion: nil)
    }
}
