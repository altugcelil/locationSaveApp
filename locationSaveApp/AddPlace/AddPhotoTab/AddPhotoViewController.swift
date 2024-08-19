//
//  AddPhotoViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 19.08.2024.
//

import UIKit

class AddPhotoViewController: UIViewController {
    @IBOutlet weak var addPhotoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addPhotoClicked(_ sender: UITapGestureRecognizer) {
        print("foto ekle tıklandı")
    }
    
}
