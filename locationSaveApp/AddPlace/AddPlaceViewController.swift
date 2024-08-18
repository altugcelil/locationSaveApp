//
//  AddPlaceViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

class AddPlaceViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, InformationViewControllerDelegate {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.layoutIfNeeded()
    }
    
    func nextButtonState(isEnabled: Bool) {
        stepTopView.rightIcon.isUserInteractionEnabled = isEnabled
        stepTopView.rightIcon.tintColor = isEnabled ? .blue : .gray
    }
    
    private func setupUI() {
        stepTopView.setLeftButtonDelegate(delegate: self)
        stepTopView.setRightButtonDelegate(delegate: self)
        stepTopView.leftIcon.tintColor = .gray
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let homePageStoryBoard = UIStoryboard(name: "InformationView", bundle: nil)
        let homePage = homePageStoryBoard.instantiateViewController(withIdentifier: "informationTab") as! InformationViewController
        homePage.delegate = self
        
        let mapStoryBoard = UIStoryboard(name: "MapView", bundle: nil)
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
    
    func validationStateDidChange(isValid: Bool) {
        nextButtonState(isEnabled: isValid)
    }
}

extension AddPlaceViewController: StepTopViewLeftButtonDelegate, StepTopViewRightButtonDelegate {
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
