//
//  AddPlaceViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

class AddPlaceViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stepTopView: StepTopView!
    
    var currentPageIndex: Int = 0
    var pageContent: [UIViewController] = []
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateButtonColors()
    }
    
    private func setupUI() {
        stepTopView.setLeftButtonDelegate(delegate: self)
        stepTopView.setRightButtonDelegate(delegate: self)
        stepTopView.leftIcon.tintColor = .gray
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let homePageStoryBoard = UIStoryboard(name: "HomePage", bundle: nil)
        let homePage = homePageStoryBoard.instantiateViewController(withIdentifier: "homePageTab")
        
        let mapStoryBoard = UIStoryboard(name: "Map", bundle: nil)
        let mapViewController = mapStoryBoard.instantiateViewController(withIdentifier: "mapTab")
        
        pageContent = [mapViewController, homePage] // Farklı ViewController'lar ekleyin
        pageViewController.setViewControllers([mapViewController], direction: .forward, animated: true, completion: nil)
        
        self.addChild(pageViewController)
        pageViewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func updateButtonColors() {
        let isFirstPage = currentPageIndex == 0
        let isLastPage = currentPageIndex == pageContent.count - 1
        
        stepTopView.leftIcon.tintColor = isFirstPage ? .gray : .blue
        stepTopView.rightIcon.tintColor = isLastPage ? .gray : .blue
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageContent.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        return previousIndex >= 0 ? pageContent[previousIndex] : nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pageContent.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < pageContent.count ? pageContent[nextIndex] : nil
    }
}

extension AddPlaceViewController : StepTopViewLeftButtonDelegate, StepTopViewRightButtonDelegate {
    func leftButtonAction() {
        let previousIndex = currentPageIndex - 1
        
        if previousIndex >= 0 {
            currentPageIndex = previousIndex
            let previousViewController = pageContent[currentPageIndex]
            pageViewController.setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
            updateButtonColors()

        }
    }
    
    func rightButtonAction() {
        let nextIndex = currentPageIndex + 1
        
        if nextIndex < pageContent.count {
            currentPageIndex = nextIndex
            let nextViewController = pageContent[currentPageIndex]
            pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
            updateButtonColors()
        }
    }
}
