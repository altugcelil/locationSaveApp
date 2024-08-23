import UIKit

@IBDesignable class ExpandingTextView: UIView {
    
    // MARK: - Public Properties
    
    @IBInspectable public var staticPlaceholderText: String = "Not giriniz..." {
        didSet {
            staticPlaceholderLabel.text = staticPlaceholderText
        }
    }
    
    @IBInspectable public var staticPlaceholderColor: UIColor = .gray {
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
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            textView.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            textView.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            textView.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var textLeftOffset: CGFloat = 0 {
        didSet {
            textView.textContainerInset.left = textLeftOffset
        }
    }
    
    @IBInspectable public var maxCharacterLimit: Int = 500

    // MARK: - Views
    
    private lazy var staticPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.font = self.staticPlaceholderFont
        label.textColor = self.staticPlaceholderColor
        label.text = self.staticPlaceholderText
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.delegate = self
        textView.font = BaseFont.adjustFontSize(of: staticPlaceholderFont, to: 14)
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 8, left: textLeftOffset, bottom: 8, right: 8)
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup view
    
    private func setupView() {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
        
        addSubview(staticPlaceholderLabel)
        addSubview(textView)
        addSubview(separatorLineView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            staticPlaceholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            staticPlaceholderLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -4),
            
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: separatorLineView.topAnchor, constant: -separatorBottomPadding),
            
            separatorLineView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: separatorLeftPadding),
            separatorLineView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -separatorRightPadding),
            separatorLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -separatorBottomPadding),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    // MARK: - Placeholder Handling
    
    private func updatePlaceholderVisibility() {
        staticPlaceholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension ExpandingTextView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholderVisibility()
        
        if textView.text.count > maxCharacterLimit {
            textView.text = String(textView.text.prefix(maxCharacterLimit))
        }
        
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        textView.isScrollEnabled = newSize.height >= 150
        textView.frame.size = CGSize(width: max(fixedWidth, newSize.width), height: newSize.height)
    }
}
