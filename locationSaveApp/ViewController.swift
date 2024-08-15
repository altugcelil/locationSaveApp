//
//  ViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        pushMain()
    }
    
    func pushMain() {
        let mainPageStoryBoard = UIStoryboard.init(name: "TabBarViewController", bundle: nil)
        let mainPage = mainPageStoryBoard.instantiateViewController(withIdentifier: "mainPageTabBar") as! TabBarViewController
        mainPage.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(mainPage, animated: true)
    }
}
