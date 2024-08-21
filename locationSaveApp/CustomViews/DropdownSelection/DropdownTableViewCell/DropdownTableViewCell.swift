//
//  DropdownTableViewCell.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 21.08.2024.
//

import UIKit

class DropdownTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(item: DropdownControllerModel) {
        itemLabel.text = item.name
        itemImage?.image = UIImage(systemName: item.imageName ?? "")
    }
}
