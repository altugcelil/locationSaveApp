//
//  Device.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 23.08.2024.
//


import Foundation
import Foundation
import UIKit

enum Device {
    case iPhoneSE
    case iPhone8
    case iPhone8Plus
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone11
    case iphone14ProMax
    
    static let baseScreenSize: Device = .iPhone11
}

extension Device: RawRepresentable {
    typealias RawValue = CGSize
    
    init?(rawValue: CGSize) {
        switch rawValue {
        case CGSize(width: 320, height: 568):
            self = .iPhoneSE
        case CGSize(width: 375, height: 667):
            self = .iPhone8
        case CGSize(width: 414, height: 736):
            self = .iPhone8Plus
        case CGSize(width: 375, height: 812):
            self = .iPhone11Pro
        case CGSize(width: 414, height: 896):
            self = .iPhone11ProMax
        case CGSize(width: 414, height: 896):
            self = .iPhone11
        case CGSize(width: 430, height: 932):
            self = .iphone14ProMax
        
        default:
            return nil
        }
    }
    
    var rawValue: CGSize {
        switch self {
        case .iPhoneSE:
            return CGSize(width: 320, height: 568)
        case .iPhone8:
            return CGSize(width: 375, height: 667)
        case .iPhone8Plus:
            return CGSize(width: 414, height: 736)
        case .iPhone11Pro:
            return CGSize(width: 375, height: 812)
        case .iPhone11ProMax:
            return CGSize(width: 414, height: 896)
        case .iPhone11:
            return CGSize(width: 414, height: 896)
        case .iphone14ProMax:
            return CGSize(width: 430, height: 932)
        }
    }
}
