//
//  DetailPageViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 21.08.2024.
//

import UIKit
import MapKit

class DetailPageViewController: UIViewController {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cityOrCountryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var placeImage: UIImageView!

    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        nameLabel.text = place?.title
        noteLabel.text = place?.note
        cityOrCountryLabel.text = place?.cityOrCountry
        ratingView.rating = place?.rating ?? 0.0
        ratingView.isUserInteractionEnabled = false
        
        if let imageData = place?.imageData, let image = UIImage(data: imageData) {
            placeImage.image = image
            placeImage.isHidden = false
        }else {
            placeImage.image = UIImage(named: "photo")
        }
        pinAndZoomOnLocation(latitude: place?.latitude ?? 0.0, longitude: place?.longitude ?? 0.0)
    }
    
    @IBAction func openMapClicked(_ sender: UIButton) {
        openLocation()
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func openMaps(latitude: Double, longitude: Double) {
        let destinationLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)
        
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        destinationMapItem.openInMaps(launchOptions: launchOptions)
    }
    
    func openLocation() {
            if let latitude = place?.latitude, let longitude = place?.longitude{
                openMaps(latitude: latitude, longitude: longitude)
            }else {
            print("Konum bilgisi alınamadı.")
        }
    }
    
    func pinAndZoomOnLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            
            let regionRadius: CLLocationDistance = 100
            let coordinateRegion = MKCoordinateRegion(center: coordinate,
                                                      latitudinalMeters: regionRadius,
                                                      longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
}
