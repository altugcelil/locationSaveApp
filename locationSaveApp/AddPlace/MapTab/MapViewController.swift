//
//  MapViewController.swift
//  locationSaveApp
//
//  Created by Altug Celil Koc (Berkut Teknoloji) on 18.08.2024.
//
import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class MapViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, GMSMapViewDelegate {
    var mapView: GMSMapView!
    var searchBar: UISearchBar!
    let placesClient = GMSPlacesClient.shared()
    let locationManager = CLLocationManager()
    var currentMarker: GMSMarker?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        
        searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 48))
        searchBar.delegate = self
        self.view.addSubview(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchPlace(query: query)
    }

    func searchPlace(query: String) {
        let filter = GMSAutocompleteFilter()
        filter.types = .none

        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { (results, error) in
            guard error == nil else {
                print("Error: \(error?.localizedDescription ?? "")")
                return
            }

            if let results = results, let firstResult = results.first {
                self.showPlaceOnMap(placeID: firstResult.placeID)
            }
        }
    }

    func showPlaceOnMap(placeID: String) {
        placesClient.fetchPlace(fromPlaceID: placeID, placeFields: .coordinate, sessionToken: nil) { (place, error) in
            guard error == nil, let place = place else {
                print("Error fetching place details: \(error?.localizedDescription ?? "")")
                return
            }

            let position = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            self.addMarkerAndZoomToPosition(position: position, title: place.name)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let position = location.coordinate
        self.addMarkerAndZoomToPosition(position: position, title: "My Location")
        
        locationManager.stopUpdatingLocation() // Konum güncellemeyi durdurma
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    func addMarkerAndZoomToPosition(position: CLLocationCoordinate2D, title: String?) {
        currentMarker?.map = nil

        currentMarker = GMSMarker(position: position)
        currentMarker?.title = title
        currentMarker?.map = self.mapView

        self.mapView.animate(toLocation: position)
        self.mapView.animate(toZoom: 15.0)
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        self.addMarkerAndZoomToPosition(position: coordinate, title: "Seçili Konum")
    }
}
