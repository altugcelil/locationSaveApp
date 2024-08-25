import Foundation

enum DropdownModel {
    case Category
    
    var headerText: String {
        switch self {
        case .Category:
            return NSLocalizedString("category_header_text", comment: "Select Category Header")
        }
    }
    
    var placeHolderText: String {
        switch self {
        case .Category:
            return NSLocalizedString("category_placeholder_text", comment: "Select Category Placeholder")
        }
    }
    
    var selectionText: String {
        switch self {
        case .Category:
            return NSLocalizedString("category_selection_text", comment: "Select Category Selection Text")
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
    Category(name: NSLocalizedString("restaurant_category", comment: "Restaurant"), imageName: "fork.knife"),
    Category(name: NSLocalizedString("cafe_category", comment: "Cafe"), imageName: "cup.and.saucer"),
    Category(name: NSLocalizedString("supermarket_category", comment: "Supermarket"), imageName: "cart"),
    Category(name: NSLocalizedString("shopping_mall_category", comment: "Shopping Mall"), imageName: "bag"),
    Category(name: NSLocalizedString("hotel_category", comment: "Hotel"), imageName: "bed.double"),
    Category(name: NSLocalizedString("park_category", comment: "Park"), imageName: "leaf"),
    Category(name: NSLocalizedString("gym_category", comment: "Gym"), imageName: "figure.walk"),
    Category(name: NSLocalizedString("pharmacy_category", comment: "Pharmacy"), imageName: "cross.case"),
    Category(name: NSLocalizedString("cinema_category", comment: "Cinema"), imageName: "film"),
    Category(name: NSLocalizedString("gas_station_category", comment: "Gas Station"), imageName: "fuelpump"),
    Category(name: NSLocalizedString("hospital_category", comment: "Hospital"), imageName: "cross.circle"),
    Category(name: NSLocalizedString("library_category", comment: "Library"), imageName: "books.vertical"),
    Category(name: NSLocalizedString("museum_category", comment: "Museum"), imageName: "building.columns"),
    Category(name: NSLocalizedString("beach_category", comment: "Beach"), imageName: "sun.max"),
    Category(name: NSLocalizedString("bar_category", comment: "Bar"), imageName: "wineglass"),
    Category(name: NSLocalizedString("theater_category", comment: "Theater"), imageName: "theatermasks"),
    Category(name: NSLocalizedString("stadium_category", comment: "Stadium"), imageName: "sportscourt"),
    Category(name: NSLocalizedString("school_category", comment: "School"), imageName: "graduationcap"),
    Category(name: NSLocalizedString("university_category", comment: "University"), imageName: "books.vertical.fill"),
    Category(name: NSLocalizedString("airport_category", comment: "Airport"), imageName: "airplane"),
    Category(name: NSLocalizedString("bus_stop_category", comment: "Bus Stop"), imageName: "bus"),
    Category(name: NSLocalizedString("train_station_category", comment: "Train Station"), imageName: "train.side.front.car"),
    Category(name: NSLocalizedString("mosque_category", comment: "Mosque"), imageName: "mosque"),
    Category(name: NSLocalizedString("church_category", comment: "Church"), imageName: "building.columns"),
    Category(name: NSLocalizedString("synagogue_category", comment: "Synagogue"), imageName: "star.circle"),
    Category(name: NSLocalizedString("zoo_category", comment: "Zoo"), imageName: "pawprint"),
    Category(name: NSLocalizedString("aquarium_category", comment: "Aquarium"), imageName: "tortoise"),
    Category(name: NSLocalizedString("amusement_park_category", comment: "Amusement Park"), imageName: "lasso.badge.sparkles"),
    Category(name: NSLocalizedString("nightclub_category", comment: "Nightclub"), imageName: "music.note"),
    Category(name: NSLocalizedString("other_category", comment: "Other"), imageName: "nosign")
]
