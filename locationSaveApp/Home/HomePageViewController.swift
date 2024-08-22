//
//  HomePageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//
import UIKit
import CoreData

class HomePageViewController: UIViewController {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var placesTableView: UITableView!
    var places: [Place] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        fetchLocations()
    }
    
    private func setupUI() {
        placesTableView.register(UINib.init(nibName: "PlacesTableViewCell", bundle: nil), forCellReuseIdentifier: "placesTableViewCell")
        placesTableView.showsHorizontalScrollIndicator = false
        placesTableView.showsVerticalScrollIndicator = false
        
        placesTableView.estimatedRowHeight = 100
        placesTableView.rowHeight = UITableView.automaticDimension
    }
    
    func fetchLocations() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
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
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesTableViewCell") as! PlacesTableViewCell
        cell.configure(imageData: place.imageData, title: place.title, note: place.note, rating: 8.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        presentPlaceDetailPage(place: place)
    }
}
