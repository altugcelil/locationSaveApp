//
//  HomePageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 16.08.2024.
//
import UIKit
import CoreData

class HomePageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var places: [Place] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocations()
    }
    
    func fetchLocations() -> [Place]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()

        do {
            let locations = try context.fetch(fetchRequest)
            places = locations
            test()
            return locations
        } catch {
            print("Failed to fetch locations: \(error)")
            return nil
        }
    }
    
    func test() {
        guard let photoData = places.last?.imageData,
                 let image = UIImage(data: photoData) else {
               print("No image data available")
               return
           }
        imageView.image = image
    }
    
    @IBAction func testTapped(_ sender: Any) {
        guard let photoData = places.last?.imageData,
                 let image = UIImage(data: photoData) else {
               print("No image data available")
               return
           }
        imageView.image = image
    }
}
