//
//  Untitled.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 30.11.2024.
//

import UIKit

extension UITableViewCell {
        var cellActionButtonLabel: UILabel? {
        for subview in self.superview?.subviews ?? [] {
            if String(describing: subview).range(of: "UISwipeActionPullView") != nil {
                for view in subview.subviews {
                    if String(describing: view).range(of: "UISwipeActionStandardButton") != nil {
                        for sub in view.subviews {
                            if let label = sub as? UILabel {
                                return label
                            }
                        }
                    }
                }
            }
        }
        return nil
    }

}
