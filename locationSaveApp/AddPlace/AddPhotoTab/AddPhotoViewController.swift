//
//  AddPhotoViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 19.08.2024.
//

import UIKit
import CoreData

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var addPhotoImageView: UIImageView!
    var placeInfo: PlaceInfoModel?
    var place: Place?

    override func viewDidLoad() {
        super.viewDidLoad()
        placeInfo = PlaceInfoModel()
    }
    
    func saveLocation(name: String, latitude: Double, longitude: Double) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let place = Place(context: context)
        place.title = "name"
        place.latitude = 40.0
        place.longitude = 41.2
        place.imageData = placeInfo?.photoData
        
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
            placeInfo?.photoData = imageData
        }
    }
    
    func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
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
                savePhoto(image: selectedImage)
            }
        }
    }
