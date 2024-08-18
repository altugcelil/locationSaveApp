//
//  InformationViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//

import Foundation
import UIKit

@IBDesignable class CustomTextField: UITextField {
    
    // MARK: - Public Properties
    
    @IBInspectable public var staticPlaceholderText: String = "" {
        didSet {
            staticPlaceholderLabel.text = staticPlaceholderText
        }
    }
    
    @IBInspectable public var staticPlaceholderColor: UIColor = .blue {
        didSet {
            staticPlaceholderLabel.textColor = staticPlaceholderColor
        }
    }
    
    @IBInspectable public var staticPlaceholderFont: UIFont = UIFont.systemFont(ofSize: 12) {
        didSet {
            staticPlaceholderLabel.font = staticPlaceholderFont
        }
    }
    
    @IBInspectable public var separatorLineViewColor: UIColor = .blue {
        didSet {
            separatorLineView.backgroundColor = separatorLineViewColor
        }
    }
    
    @IBInspectable public var separatorLeftPadding: CGFloat = 0
    @IBInspectable public var separatorRightPadding: CGFloat = 0
    @IBInspectable public var separatorBottomPadding: CGFloat = 0
    
    @IBInspectable public var separatorIsHidden: Bool = false {
        didSet {
            separatorLineView.isHidden = separatorIsHidden
        }
    }
    
    // MARK: - Views
    
    private lazy var staticPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = self.staticPlaceholderFont
        label.textColor = self.staticPlaceholderColor
        label.text = self.staticPlaceholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = self.separatorLineViewColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        addSubview(staticPlaceholderLabel)
        addSubview(separatorLineView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            staticPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            staticPlaceholderLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -4),
            
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separatorLeftPadding),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -separatorRightPadding),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -separatorBottomPadding),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
