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
        homePage.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house"))
        homePage.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        let addPlaceStoryBoard = UIStoryboard.init(name: "AddPlace", bundle: nil)
        let secondVc = addPlaceStoryBoard.instantiateViewController(withIdentifier: "addPlaceTab")
        secondVc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), selectedImage: UIImage(systemName: "plus"))
        secondVc.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        let homePageStoryBoarddd = UIStoryboard.init(name: "HomePage", bundle: nil)
        let thirdVc = homePageStoryBoarddd.instantiateViewController(withIdentifier: "homePageTab")
        thirdVc.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "gearshape"), selectedImage: UIImage(systemName: "gearshape"))
        thirdVc.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        viewControllers = [homePage, secondVc, thirdVc]
    }
}
