//
//  PlaceCategory.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 30.11.2024.
//


import Foundation

enum PlaceCategory: String, CaseIterable {
    case restaurant
    case cafe
    case supermarket
    case shoppingMall
    case hotel
    case park
    case gym
    case pharmacy
    case cinema
    case gasStation
    case hospital
    case library
    case museum
    case beach
    case bar
    case theater
    case stadium
    case school
    case university
    case airport
    case busStop
    case trainStation
    case mosque
    case church
    case synagogue
    case zoo
    case aquarium
    case amusementPark
    case nightclub
    case other
    
    var localizedName: String {
        switch self {
        case .restaurant:
            return NSLocalizedString("restaurant_category", comment: "")
        case .cafe:
            return NSLocalizedString("cafe_category", comment: "")
        case .supermarket:
            return NSLocalizedString("supermarket_category", comment: "")
        case .shoppingMall:
            return NSLocalizedString("shopping_mall_category", comment: "")
        case .hotel:
            return NSLocalizedString("hotel_category", comment: "")
        case .park:
            return NSLocalizedString("park_category", comment: "")
        case .gym:
            return NSLocalizedString("gym_category", comment: "")
        case .pharmacy:
            return NSLocalizedString("pharmacy_category", comment: "")
        case .cinema:
            return NSLocalizedString("cinema_category", comment: "")
        case .gasStation:
            return NSLocalizedString("gas_station_category", comment: "")
        case .hospital:
            return NSLocalizedString("hospital_category", comment: "")
        case .library:
            return NSLocalizedString("library_category", comment: "")
        case .museum:
            return NSLocalizedString("museum_category", comment: "")
        case .beach:
            return NSLocalizedString("beach_category", comment: "")
        case .bar:
            return NSLocalizedString("bar_category", comment: "")
        case .theater:
            return NSLocalizedString("theater_category", comment: "")
        case .stadium:
            return NSLocalizedString("stadium_category", comment: "")
        case .school:
            return NSLocalizedString("school_category", comment: "")
        case .university:
            return NSLocalizedString("university_category", comment: "")
        case .airport:
            return NSLocalizedString("airport_category", comment: "")
        case .busStop:
            return NSLocalizedString("bus_stop_category", comment: "")
        case .trainStation:
            return NSLocalizedString("train_station_category", comment: "")
        case .mosque:
            return NSLocalizedString("mosque_category", comment: "")
        case .church:
            return NSLocalizedString("church_category", comment: "")
        case .synagogue:
            return NSLocalizedString("synagogue_category", comment: "")
        case .zoo:
            return NSLocalizedString("zoo_category", comment: "")
        case .aquarium:
            return NSLocalizedString("aquarium_category", comment: "")
        case .amusementPark:
            return NSLocalizedString("amusement_park_category", comment: "")
        case .nightclub:
            return NSLocalizedString("nightclub_category", comment: "")
        case .other:
            return NSLocalizedString("other_category", comment: "")
        }
    }
    
    var imageName: String {
        switch self {
        case .restaurant:
            return "fork.knife"
        case .cafe:
            return "cup.and.saucer"
        case .supermarket:
            return "cart"
        case .shoppingMall:
            return "bag"
        case .hotel:
            return "bed.double"
        case .park:
            return "leaf"
        case .gym:
            return "figure.walk"
        case .pharmacy:
            return "cross.case"
        case .cinema:
            return "film"
        case .gasStation:
            return "fuelpump"
        case .hospital:
            return "cross.circle"
        case .library:
            return "books.vertical"
        case .museum:
            return "building.columns"
        case .beach:
            return "sun.max"
        case .bar:
            return "wineglass"
        case .theater:
            return "theatermasks"
        case .stadium:
            return "sportscourt"
        case .school:
            return "graduationcap"
        case .university:
            return "books.vertical.fill"
        case .airport:
            return "airplane"
        case .busStop:
            return "bus"
        case .trainStation:
            return "train.side.front.car"
        case .mosque:
            return "mosque"
        case .church:
            return "building.columns"
        case .synagogue:
            return "star.circle"
        case .zoo:
            return "pawprint"
        case .aquarium:
            return "tortoise"
        case .amusementPark:
            return "lasso.badge.sparkles"
        case .nightclub:
            return "music.note"
        case .other:
            return "nosign"
        }
    }
    
    static func from(localizedName: String) -> PlaceCategory? {
        return PlaceCategory.allCases.first { $0.localizedName == localizedName }
    }
} 
