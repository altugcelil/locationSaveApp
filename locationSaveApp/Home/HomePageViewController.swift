//
//  HomePageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//
import UIKit
import CoreData

class HomePageViewController: UIViewController, FilterSelectionDelegate {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    
    private var places: [Place] = []
    private var filteredPlaces: [Place] = []
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFontSize()
        setupSearchBarUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fetchLocations()
    }
    
    private func setupUI() {
        self.hideKeyboardWhenTappedAround()
        placesTableView.register(UINib.init(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "placesTableViewCell")
        placesTableView.showsHorizontalScrollIndicator = false
        placesTableView.showsVerticalScrollIndicator = false
        
        placesTableView.estimatedRowHeight = 100
        placesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupFontSize() {
        headerLabel.font = BaseFont.adjustFontSize(of: headerLabel.font, to: 18)
    }
    
    private func setupSearchBarUI() {
        searchBar.delegate = self
        searchBar.placeholder = "Kayıtlı Yerlerde Ara"
    }
    
    func didApplyFilters(selectedCategories: Set<String>, selectedCities: Set<String>) {
        fetchLocations(categories: selectedCategories, cities: selectedCities)
    }

    @IBAction func filterButtonClicked(_ sender: UIButton) {
        presentFilterPage()
    }
    
    func fetchLocations(categories: Set<String> = [], cities: Set<String> = []) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        
        var predicates: [NSPredicate] = []
        
        // Kategoriler için filtre ekleme
        if !categories.isEmpty {
            let categoryPredicate = NSPredicate(format: "categoryName IN %@", Array(categories))
            predicates.append(categoryPredicate)
        }
        
        // Şehirler için filtre ekleme
        if !cities.isEmpty {
            let cityPredicate = NSPredicate(format: "cityOrCountry IN %@", Array(cities))
            predicates.append(cityPredicate)
        }
        
        // Tüm filtreleri birleştirme
        if !predicates.isEmpty {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
            fetchRequest.predicate = compoundPredicate
        }
        
        do {
            let locations = try context.fetch(fetchRequest)
            places = locations
            placesTableView.reloadData()
        } catch {
            print("Failed to fetch locations: \(error)")
        }
    }

    
    func presentPlaceDetailPage(place: Place) {
        let placeDetailViewController = DetailPageViewController(nibName: "DetailPageView", bundle: nil)
        placeDetailViewController.place = place
        placeDetailViewController.modalPresentationStyle = .pageSheet
        placeDetailViewController.modalTransitionStyle = .coverVertical
        present(placeDetailViewController, animated: true, completion: nil)
    }
    
    func presentFilterPage() {
        let filterPageViewController = FilterSelectionViewController(nibName: "FilterSelectionView", bundle: nil)
        filterPageViewController.delegate = self

        filterPageViewController.modalPresentationStyle = .pageSheet
        filterPageViewController.modalTransitionStyle = .coverVertical
        present(filterPageViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredPlaces.count : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = isSearching ? filteredPlaces[indexPath.row] : places[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesTableViewCell") as! PlacesTableViewCell
        cell.configure(imageData: place.imageData, title: place.title, note: place.note, rating: 8.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = isSearching ? filteredPlaces[indexPath.row] : places[indexPath.row]
        presentPlaceDetailPage(place: place)
    }
}

// MARK: - UISearchBarDelegate
extension HomePageViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredPlaces.removeAll()
        } else {
            isSearching = true
            filteredPlaces = places.filter { place in
                let searchTextLowercased = searchText.lowercased()
                return (place.title?.lowercased().contains(searchTextLowercased) ?? false) ||
                       (place.note?.lowercased().contains(searchTextLowercased) ?? false) ||
                       (place.cityOrCountry?.lowercased().contains(searchTextLowercased) ?? false)
            }
        }
        placesTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.text = ""
        placesTableView.reloadData()
    }
}

