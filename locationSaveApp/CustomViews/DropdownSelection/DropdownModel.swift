//
//  DropdownModel.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 21.08.2024.
//

import Foundation
enum DropdownModel {
    case Category
    
    var headerText: String {
        switch self {
        case .Category:
            return "Kategori Seç"
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .Category:
            return "Kaydetmek istediğiniz yer için kategori seçiniz."
        }
    }
    
    var selectionText: String {
        switch self {
        case .Category:
            return "Kaydetmek istediğiniz yer için kategori seçiniz."
        }
    }
}

struct DropdownControllerModel {
    var name: String?
    var id: Int?
    var imageName: String?
}

struct Category {
    let name: String
    let imageName: String
}

let categories: [Category] = [
    Category(name: "Restoran", imageName: "fork.knife"),
    Category(name: "Kafe", imageName: "cup.and.saucer"),
    Category(name: "Süpermarket", imageName: "cart"),
    Category(name: "Alışveriş Merkezi", imageName: "bag"),
    Category(name: "Otel", imageName: "bed.double"),
    Category(name: "Park", imageName: "leaf"),
    Category(name: "Spor Salonu", imageName: "figure.walk"),
    Category(name: "Eczane", imageName: "cross.case"),
    Category(name: "Sinema", imageName: "film"),
    Category(name: "Benzin İstasyonu", imageName: "fuelpump"),
    Category(name: "Hastane", imageName: "cross.circle"),
    Category(name: "Kütüphane", imageName: "books.vertical"),
    Category(name: "Müze", imageName: "building.columns"),
    Category(name: "Plaj", imageName: "sun.max"),
    Category(name: "Bar", imageName: "wineglass"),
    Category(name: "Tiyatro", imageName: "theatermasks"),
    Category(name: "Stadyum", imageName: "sportscourt"),
    Category(name: "Okul", imageName: "graduationcap"),
    Category(name: "Üniversite", imageName: "books.vertical.fill"),
    Category(name: "Havalimanı", imageName: "airplane"),
    Category(name: "Otobüs Durağı", imageName: "bus"),
    Category(name: "Tren İstasyonu", imageName: "train.side.front.car"),
    Category(name: "Cami", imageName: "mosque"),
    Category(name: "Kilise", imageName: "building.columns"),
    Category(name: "Sinagog", imageName: "star.circle"),
    Category(name: "Hayvanat Bahçesi", imageName: "pawprint"),
    Category(name: "Akvaryum", imageName: "tortoise"),
    Category(name: "Lunapark", imageName: "lasso.badge.sparkles"),
    Category(name: "Gece Kulübü", imageName: "music.note"),
    Category(name: "Diğer", imageName: "nosign")
]
