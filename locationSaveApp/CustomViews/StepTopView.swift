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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var rightIcon: UIImageView!
    @IBOutlet weak var leftIcon: UIImageView!
    weak var leftImageViewDelegate: StepTopViewLeftButtonDelegate?
    weak var rightImageViewDelegate: StepTopViewRightButtonDelegate?
    
    @objc func rightImageClicked () {
        rightImageViewDelegate?.rightButtonAction()
    }
    
    @objc func leftImageClicked () {
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
        setupFonts()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("StepTopView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
        
        let rightImageGesture = UITapGestureRecognizer(target: self, action: #selector(rightImageClicked))
        rightIcon.addGestureRecognizer(rightImageGesture)
        rightIcon.isUserInteractionEnabled = true
        
        let leftImageGesture = UITapGestureRecognizer(target: self, action: #selector(leftImageClicked))
        leftIcon.addGestureRecognizer(leftImageGesture)
        leftIcon.isUserInteractionEnabled = true
    }
    
    private func setupFonts() {
        titleLabel.textColor = .black
    }
    
    func setView(title: String) {
        titleLabel.text = title
    }
}
