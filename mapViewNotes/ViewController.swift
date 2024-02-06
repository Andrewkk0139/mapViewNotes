//
//  ViewController.swift
//  mapViewNotes
//
//  Created by ANDREW KAISER on 1/29/24.
//

import UIKit
import MapKit
class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapOutlet: MKMapView!
    
    var currentLocation : CLLocation!
    var parks : [MKMapItem] = []
    
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
        mapOutlet.showsUserLocation = true
        
        // CL stands for Core Location
        let center = CLLocationCoordinate2D(latitude: 42.2371, longitude: -88.3226)
        let center2 = locationManager.location!.coordinate
        // span is like how far zoomed in on a cord location!
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1600, longitudinalMeters: 1600)
        let region2 = MKCoordinateRegion(center: center, span: span)
        
        mapOutlet.setRegion(region2, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // [0] is the most recent location
        currentLocation =  locations[0]
    }
    
    @IBAction func searchButton(_ sender: Any) {
        // blank request obj
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Parks"
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        // anything with MK is in the MapKit package
        let search = MKLocalSearch(request: request)
        // start the search
        search.start { (response, error) in
            // response and error are like parameters for the completion
            // guards are similar to if let
            guard let response = response
            else{return} // in guards you always want to return.
            // if we have a response, go on.
            for mapItem in response.mapItems{
                self.parks.append(mapItem)
                //annotations are the red pins... i think
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapOutlet.addAnnotation(annotation)
            }
        }
    }
    
    
    
}

