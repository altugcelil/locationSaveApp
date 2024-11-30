//
//  PlacesTableViewCell.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 21.08.2024.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by:  UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0))
    }
    
    private func setupUI() {
        setupFontSize()
        
        selectionStyle = .none
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 0.65
        contentView.layer.borderColor = UIColor(named: "DarkModeBlack")?.cgColor
    }
    
    private func setupFontSize() {
        titleLabel.font = BaseFont.adjustFontSize(of: titleLabel.font, to: 16)
        noteLabel.font = BaseFont.adjustFontSize(of: noteLabel.font, to: 12)
    }
    
    func configure(imageData: Data?, title: String?, note: String?, rating: Float?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            placeImage.image = image
            placeImage.isHidden = false
            noteLabel.text = note ?? "Bu yer için kayıtlı bir not bulunamadı."
            titleLabel.text = title
        }else {
            placeImage.image = UIImage(systemName: "xmark.rectangle")
            noteLabel.text = note ?? "Bu yer için kayıtlı bir not ve fotoğraf bulunamadı."
            titleLabel.text = title
        }
    }
}
