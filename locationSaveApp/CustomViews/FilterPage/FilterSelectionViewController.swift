//
//  FilterSelectionViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 23.08.2024.
//

import UIKit
import CoreData

protocol FilterSelectionDelegate: AnyObject {
    func didApplyFilters(selectedCategories: Set<String>, selectedCities: Set<String>)
}

class FilterSelectionViewController: UIViewController {
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var categoryHeaderLabel: UILabel!

    @IBOutlet weak var cityCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var cityOrCountryCollectionView: UICollectionView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    weak var delegate: FilterSelectionDelegate?

    var places: [Place] = []
    var filteredCategories: [String] = []
    var filteredCities: [String] = []

    private var selectedCategories: Set<String> = []
    private var selectedCities: Set<String> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFontSize()
        fetchLocations()
        setupCollectionViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let heightCity = cityOrCountryCollectionView.collectionViewLayout.collectionViewContentSize.height
        cityCollectionViewHeight.constant = heightCity
        
        let heightCategory = categoryCollectionView.collectionViewLayout.collectionViewContentSize.height
        categoryCollectionViewHeight.constant = heightCategory
        self.view.layoutIfNeeded()
    }
    
    private func setupFontSize() {
        cityCountryLabel.font = BaseFont.adjustFontSize(of: cityCountryLabel.font, to: 24)
        categoryHeaderLabel.font = BaseFont.adjustFontSize(of: categoryHeaderLabel.font, to: 24)
    }

    func fetchLocations() {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
            do {
                let locations = try context.fetch(fetchRequest)
                places = locations
                filterPlaces()
            } catch {
                print("Failed to fetch locations: \(error)")
            }
            categoryCollectionView.reloadData()
        }
        
    private func setupCollectionViews() {
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
                
        categoryCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCollectionViewCell")
        cityOrCountryCollectionView.register(UINib(nibName: "FilterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "filterCollectionViewCell")
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.allowsMultipleSelection = true
        
        cityOrCountryCollectionView.delegate = self
        cityOrCountryCollectionView.dataSource = self
        cityOrCountryCollectionView.allowsMultipleSelection = true
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        delegate?.didApplyFilters(selectedCategories: [], selectedCities: [])
        self.dismiss(animated: true)
    }
    
    @IBAction func applyButtonClicked(_ sender: UIButton) {
        delegate?.didApplyFilters(selectedCategories: selectedCategories, selectedCities: selectedCities)
        self.dismiss(animated: true)
    }
    
    private func filterPlaces() {
        filteredCategories = places.compactMap { $0.categoryName }
            .filter { !$0.isEmpty }
            .reduce(into: [String]()) { result, category in
                if !result.contains(category) {
                    result.append(category)
                }
            }
        filteredCities = places.compactMap { $0.cityOrCountry }
            .filter { !$0.isEmpty }
            .reduce(into: [String]()) { result, city in
                if !result.contains(city) {
                    result.append(city)
                }
            }
        categoryCollectionView.reloadData()
        cityOrCountryCollectionView.reloadData()
    }
}

extension FilterSelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cityOrCountryCollectionView {
            return filteredCities.count
        } else if collectionView == categoryCollectionView {
            return filteredCategories.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        if collectionView == cityOrCountryCollectionView {
            let city = filteredCities[indexPath.row]
            cell.configure(text: city)
        } else if collectionView == categoryCollectionView {
            let category = filteredCategories[indexPath.row]
            cell.configure(text:category)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let category = filteredCategories[indexPath.row]
            selectedCategories.insert(category)
        } else if collectionView == cityOrCountryCollectionView {
            let city = filteredCities[indexPath.row]
            selectedCities.insert(city)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.setSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            let category = filteredCategories[indexPath.row]
            selectedCategories.remove(category)
        } else if collectionView == cityOrCountryCollectionView {
            let city = filteredCities[indexPath.row]
            selectedCities.remove(city)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell {
            cell.setUnSelected()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        let collectionViewWidth = collectionView.frame.width
        let availableWidth = collectionViewWidth - (padding * 5)
        let itemWidth = availableWidth / 3

        let itemHeight: CGFloat = 30

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
