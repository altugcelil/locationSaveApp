//
//  AddPlaceViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

class AddPlaceViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, InformationViewControllerDelegate, MapViewControllerDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var stepTopView: StepTopView!
    
    var currentPageIndex: Int = 0
    var pageContent: [UIViewController] = []
    var pageViewController: UIPageViewController!
    var pageModel: [PageModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
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
        setupFontSize()
        
        stepTopView.setLeftButtonDelegate(delegate: self)
        stepTopView.setRightButtonDelegate(delegate: self)
        stepTopView.leftIcon.tintColor = .gray
        stepTopView.rightIcon.tintColor = .gray
        stepTopView.rightIcon.isUserInteractionEnabled = false
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = nil
        pageViewController.delegate = self
        
        for gesture in pageViewController.gestureRecognizers {
            gesture.isEnabled = false
        }
        
        let informationView = UIStoryboard(name: "InformationView", bundle: nil)
        let informationViewController = informationView.instantiateViewController(withIdentifier: "informationTab") as! InformationViewController
        informationViewController.delegate = self
        
        let mapStoryBoard = UIStoryboard(name: "MapView", bundle: nil)
        let mapViewController = mapStoryBoard.instantiateViewController(withIdentifier: "mapTab") as! MapViewController
        mapViewController.delegate = self
        
        let addPhotoStoryBoard = UIStoryboard(name: "AddPhotoView", bundle: nil)
        if let addPhotoViewController = addPhotoStoryBoard.instantiateViewController(withIdentifier: "addPhotoTab") as? AddPhotoViewController {
            addPhotoViewController.topViewDelegate = self
            
            pageModel = [
                PageModel(
                    title: "1/3",
                    info: NSLocalizedString("map_info_text", comment: ""),
                    viewController: mapViewController
                ),
                PageModel(
                    title: "2/3",
                    info: NSLocalizedString("information_info_text", comment: ""),
                    viewController: informationViewController
                ),
                PageModel(
                    title: "3/3",
                    info: NSLocalizedString("add_photo_info_text", comment: ""),
                    viewController: addPhotoViewController
                )
            ]
            
            
            pageContent = [mapViewController, informationViewController, addPhotoViewController]
            pageViewController.setViewControllers([mapViewController], direction: .forward, animated: true, completion: nil)
        }
        
        updatePageInfo(for: currentPageIndex)
        
        self.addChild(pageViewController)
        pageViewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupFontSize() {
        infoLabel.font = BaseFont.adjustFontSize(of: infoLabel.font, to: 16)
    }
    
    private func updatePageInfo(for index: Int) {
        let page = pageModel[index]
        infoLabel.text = page.info
        stepTopView.titleLabel.text = page.title
        let progress = Float(index + 1) / Float(pageContent.count)
        stepTopView.progressBar.setProgress(progress, animated: true)
        
        if index == pageContent.count - 1 {
            stepTopView.rightIcon.setImage(UIImage(), for: .normal) //
            stepTopView.rightIcon.setTitle(NSLocalizedString("save", comment: ""), for: .normal) //
        } else {
            stepTopView.rightIcon.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            stepTopView.rightIcon.setTitle("", for: .normal) //
        }
    }
    
    
    private func updateButtonColors() {
        let isFirstPage = currentPageIndex == 0
        stepTopView.leftIcon.tintColor = isFirstPage ? .gray : .blue
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
            updatePageInfo(for: currentPageIndex)
        }
    }
    
    func rightButtonAction() {
        if currentPageIndex == pageContent.count - 1 { // AddPhotoViewController index
            let currentViewController = pageContent[currentPageIndex] as? AddPhotoViewController
            currentViewController?.saveLocation()
            currentViewController?.topViewDelegate?.didTapNextButton()
        } else {
            // Normal geçiş işlemi
            let nextIndex = currentPageIndex + 1
            if nextIndex < pageContent.count {
                currentPageIndex = nextIndex
                let nextViewController = pageContent[currentPageIndex]
                pageViewController.setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
                updateButtonColors()
                updatePageInfo(for: currentPageIndex)
            }
        }
    }
}
extension AddPlaceViewController: AddPhotoViewControllerTopViewDelegate {
    func didTapNextButton() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            let storyboard = UIStoryboard(name: "TabBarViewController", bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "mainPageTabBar")
            window.rootViewController = initialViewController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
