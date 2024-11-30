//
//  HomePageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//
import UIKit
import CoreData

class HomePageViewController: UIViewController, FilterSelectionDelegate {
    @IBOutlet weak var warningText: UILabel!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var placesTableView: UITableView!
    
    private var places: [Place] = []
    private var filteredPlaces: [Place] = []
    private var isSearching = false
    private var isFiltered = false
    private lazy var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("AppDelegate bulunamadı")
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchLocations()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fetchLocations()
    }
    
    private func setupUI() {
        setupTexts()
        
        self.hideKeyboardWhenTappedAround()
        placesTableView.register(UINib.init(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "placesTableViewCell")
        placesTableView.showsHorizontalScrollIndicator = false
        placesTableView.showsVerticalScrollIndicator = false
        
        placesTableView.estimatedRowHeight = 100
        placesTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupTexts() {
        headerLabel.text = NSLocalizedString("saved_places", comment: "")
    }
    
    private func setupFontSize() {
        headerLabel.font = BaseFont.adjustFontSize(of: headerLabel.font, to: 18)
    }
    
    private func setupSearchBarUI() {
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("search_on_save", comment: "")
    }
    
    func didApplyFilters(selectedCategories: Set<String>, selectedCities: Set<String>) {
        fetchLocationsForFilter(categories: selectedCategories, cities: selectedCities)
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        presentFilterPage()
    }
    
    func fetchLocations() {
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        
        do {
            places = try context.fetch(fetchRequest)
            placesTableView.reloadData()
            if places.isEmpty {
                updateUIForPlaces(isFilter: false)
            }
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }
    
    func fetchLocationsForFilter(categories: Set<String> = [], cities: Set<String> = []) {
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
            if places.isEmpty {
                updateUIForPlaces(isFilter: true)
            }else {
                warningView.isHidden = true
                filterButton.isHidden = false
                searchBar.isHidden = false
                placesTableView.isHidden = false
                placesTableView.reloadData()
            }
        } catch {
            print("Failed to fetch locations: \(error)")
        }
    }
    
    private func updateUIForPlaces(isFilter: Bool) {
        if isFilter {
            warningText.text = NSLocalizedString("no_place_filter", comment: "")
            warningView.isHidden = false
            filterButton.isHidden = false
            searchBar.isHidden = false
            placesTableView.isHidden = true
        }else {
            warningText.text = NSLocalizedString("no_place", comment: "")
            warningView.isHidden = false
            filterButton.isHidden = true
            searchBar.isHidden = true
            placesTableView.isHidden = true
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
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(placeDeleted),
            name: NSNotification.Name("PlaceDeleted"),
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(placeEdited),
            name: NSNotification.Name("PlaceEdited"),
            object: nil
        )
    }
    
    @objc private func placeDeleted() {
        fetchLocations()
    }
    
    @objc private func placeEdited() {
        fetchLocations()
    }
    
    
    func presentEditPage(place: Place) {
        let editViewController = EditPlaceViewController()
        editViewController.place = place
        editViewController.modalPresentationStyle = .overFullScreen
        editViewController.modalTransitionStyle = .coverVertical
        present(editViewController, animated: true)
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
        cell.configure(imageData: place.imageData, title: place.title, note: place.note, rating: place.rating)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = isSearching ? filteredPlaces[indexPath.row] : places[indexPath.row]
        presentPlaceDetailPage(place: place)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Delete Action
        let deleteAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: NSLocalizedString("delete_alert_title", comment: ""),
                message: NSLocalizedString("delete_alert_message", comment: ""),
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel_button", comment: ""), style: .cancel) { _ in
                completion(false)
            })
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("delete_button", comment: ""), style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                
                let place = self.places[indexPath.row]
                self.context.delete(place)
                
                do {
                    try self.context.save()
                    self.places.remove(at: indexPath.row)
                    tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .fade)
                    completion(true)
                    fetchLocations()
                } catch {
                    print("Silme işlemi başarısız: \(error)")
                    completion(false)
                }
            })
            
            self.present(alert, animated: true)
        }
        
        // Edit Action
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completion) in
            guard let self = self else { return }
            let place = self.isSearching ? self.filteredPlaces[indexPath.row] : self.places[indexPath.row]
            self.presentEditPage(place: place)
            completion(true)
        }
        
        // Action görünümlerini özelleştir
        deleteAction.backgroundColor = .darkModeWhite
        editAction.backgroundColor = .darkModeWhite
        
        // Custom view'ları oluştur
        let deleteTitle = NSLocalizedString("delete_button", comment: "")
        let editTitle = NSLocalizedString("edit_button", comment: "")
        
        deleteAction.image = createActionImage(title: deleteTitle, textColor: .red)
        editAction.image = createActionImage(title: editTitle, textColor: .systemBlue)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
}

private func createActionImage(title: String, textColor: UIColor) -> UIImage? {
    let size = CGSize(width: 100, height: 50)
    let renderer = UIGraphicsImageRenderer(size: size)
    
    return renderer.image { context in
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: textColor
        ]
        
        let text = NSString(string: title)
        let textSize = text.size(withAttributes: attributes)
        let point = CGPoint(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2
        )
        
        text.draw(at: point, withAttributes: attributes)
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
                (place.cityOrCountry?.lowercased().contains(searchTextLowercased) ?? false) ||
                (place.categoryName?.lowercased().contains(searchTextLowercased) ?? false)
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


