//
//  StepTopView.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import UIKit

protocol StepTopViewLeftButtonDelegate: AnyObject {
    func leftButtonAction()
}

protocol StepTopViewRightButtonDelegate: AnyObject {
    func rightButtonAction()
}

class StepTopView: UIView {

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rightIcon: UIButton!
    @IBOutlet weak var leftIcon: UIButton!
    weak var leftImageViewDelegate: StepTopViewLeftButtonDelegate?
    weak var rightImageViewDelegate: StepTopViewRightButtonDelegate?
    
    @IBAction func rightButtonClicked(_ sender: UIButton) {
        rightImageViewDelegate?.rightButtonAction()
    }
    
    @IBAction func leftButtonClicked(_ sender: UIButton) {
        leftImageViewDelegate?.leftButtonAction()
    }
    
    func setLeftButtonDelegate(delegate: StepTopViewLeftButtonDelegate) {
        leftImageViewDelegate = delegate
    }
    
    func setRightButtonDelegate(delegate: StepTopViewRightButtonDelegate) {
        rightImageViewDelegate = delegate
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("StepTopView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        progressBar.progressTintColor = .blue
    }
        
    func setView(title: String) {
        titleLabel.text = title
    }
}
