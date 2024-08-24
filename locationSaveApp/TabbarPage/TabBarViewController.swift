//
//  TabBarViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    @IBOutlet weak var mainPageTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let homePageStoryBoard = UIStoryboard.init(name: "HomePage", bundle: nil)
        let homePage = homePageStoryBoard.instantiateViewController(withIdentifier: "homePageTab")
        homePage.tabBarItem = UITabBarItem(title: "Kayıtlı Yerler", image: UIImage(systemName: "location"), selectedImage: UIImage(systemName: "location.fill"))
        homePage.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let addPlaceStoryBoard = UIStoryboard.init(name: "AddPlaceView", bundle: nil)
        let secondVc = addPlaceStoryBoard.instantiateViewController(withIdentifier: "addPlaceTab")
        secondVc.tabBarItem = UITabBarItem(title: "Yer Ekle", image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus.circle.fill"))
        secondVc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let infoPageStoryBoard = UIStoryboard.init(name: "InfoPageView", bundle: nil)
        let thirdVc = infoPageStoryBoard.instantiateViewController(withIdentifier: "infoPageTab")
        thirdVc.tabBarItem = UITabBarItem(title: "Bilgi", image: UIImage(systemName: "info.circle"), selectedImage: UIImage(systemName: "info.circle.fill"))
        thirdVc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        viewControllers = [homePage, secondVc, thirdVc]
    }
}
