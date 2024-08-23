//
//  FilterCollectionViewCell.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 23.08.2024.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var outView: UIView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var checkIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel.numberOfLines = 0
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
    }
    
    func configure(text: String?) {
          textLabel.text = text
      }
    
    func setSelected() {
        checkIcon.image = UIImage(systemName: "checkmark.circle")
    }
    
    func setUnSelected() {
        checkIcon.image = UIImage(systemName: "circle")
    }
}
