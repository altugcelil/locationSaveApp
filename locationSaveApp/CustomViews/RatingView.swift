//
//  RatingView.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 20.08.2024.
//

import Foundation
import UIKit

protocol RatingViewDelegate: AnyObject {
    func ratingView(_ ratingView: RatingView, didUpdateRating rating: Float)
}

class RatingView: UIView {

    weak var delegate: RatingViewDelegate?
    private var starButtons = [UIButton]()
    private let starCount = 10
    var rating: Float = 0 {
        didSet {
            updateStarButtons()
            delegate?.ratingView(self, didUpdateRating: rating)
        }
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
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        for _ in 1...starCount {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.setImage(UIImage(systemName: "star.fill"), for: .selected)
            button.setImage(UIImage(systemName: "star.lefthalf.fill"), for: .highlighted)
            button.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(button)
            stackView.addArrangedSubview(button)
        }

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
    }

    @objc private func starTapped(_ sender: UIButton) {
        guard let index = starButtons.firstIndex(of: sender) else { return }
        rating = Float(index) + 1
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        let widthPerStar = frame.width / CGFloat(starCount)
        
        var newRating = Float(location.x / widthPerStar)
        
        if newRating > Float(Int(newRating)) + 0.5 {
            newRating = ceil(newRating)
        } else {
            newRating = floor(newRating) + 0.5
        }

        rating = min(max(newRating, 0), Float(starCount))
        
        if gesture.state == .ended {
            delegate?.ratingView(self, didUpdateRating: rating)
        }
    }

    private func updateStarButtons() {
        for (index, button) in starButtons.enumerated() {
            if Float(index) + 0.5 == rating {
                button.setImage(UIImage(systemName: "star.lefthalf.fill"), for: .normal)
                button.tintColor = .systemYellow
            } else if Float(index) < rating {
                button.setImage(UIImage(systemName: "star.fill"), for: .normal)
                button.tintColor = .systemYellow
            } else {
                button.setImage(UIImage(systemName: "star"), for: .normal)
                button.tintColor = .systemTeal
            }
        }
    }
}
