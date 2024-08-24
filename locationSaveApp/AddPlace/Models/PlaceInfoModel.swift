//
//  PlaceInfoModel.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 19.08.2024.
//

import Foundation
import UIKit

class PlaceInfoModel {
    static let instance = PlaceInfoModel()
    
    var latitude: Double?
    var longitude: Double?
    var cityOrCountry: String?
    var title: String?
    var categoryName: String?
    var note: String?
    var rating: Float?
    var photoData: Data?
    
    func clear() {
           latitude = nil
           longitude = nil
           cityOrCountry = nil
           title = nil
           note = nil
           rating = nil
           photoData = nil
           categoryName = nil
       }
}
