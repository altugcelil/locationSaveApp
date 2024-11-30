//
//  ViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//

import UIKit
import FirebaseDatabase
import Network

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushMain()
//        if isConnectedToNetwork() {
//            checkForUpdate()
//        } else {
//            pushMain()
//        }
    }

    func pushMain() {
        let mainPageStoryBoard = UIStoryboard.init(name: "TabBarViewController", bundle: nil)
        let mainPage = mainPageStoryBoard.instantiateViewController(withIdentifier: "mainPageTabBar") as! TabBarViewController
        mainPage.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(mainPage, animated: true)
    }
    
    func checkForUpdate() {
        let ref = Database.database().reference()
        ref.child("appConfig/forceUpdate/minimum_version").observeSingleEvent(of: .value) { snapshot in
            if let minimumVersion = snapshot.value as? String {
                let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
                if currentVersion.compare(minimumVersion, options: .numeric) == .orderedAscending {
                    self.showUpdateAlert()
                }else {
                    self.pushMain()
                }
            } else {
                print("Minimum version bilgisi alınamadı.")
                self.pushMain()
            }
        }
    }
    
    func showUpdateAlert() {
        let alert = UIAlertController(title: "Güncelleme Gerekli", message: "Uygulamayı kullanmaya devam edebilmek için lütfen uygulamanızı güncelleyin.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Güncelle", style: .default, handler: { _ in
            if let url = URL(string: "app store url'niz buraya gelecek") {
                UIApplication.shared.open(url)
            }
        }))
        self.present(alert, animated: true)
    }
}
