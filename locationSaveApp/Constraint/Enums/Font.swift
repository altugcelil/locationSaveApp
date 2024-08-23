//
//  Font.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 23.08.2024.
//
import Foundation
import UIKit

enum BaseFont {
    static func adjustFontSize(of font: UIFont, to size: CGFloat) -> UIFont {
        return UIFont(descriptor: font.fontDescriptor, size: size.adaptedFontSize)
    }
}
