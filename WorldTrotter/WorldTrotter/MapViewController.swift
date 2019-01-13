//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Miguel Orozco on 1/2/19.
//  Copyright © 2019 m68476521. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    //keeps track of current pin index:
    var selectedAnnotationIndex: Int = -1
    
    override func loadView() {
        mapView = MKMapView()
        mapView.delegate = self
        locationManager = CLLocationManager()
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard", "Hybrid", "Satellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self,
                                   action: #selector(MapViewController.mapTypeChanged(_:)),
                                   for: .valueChanged)
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        initLocalizatinButton(segmentedControl)
        
        //create array of location objects:
        var locations = [Locations]()
        locations.append(Locations(name: "New York City", lat: 40.730872, long: -74.003066))
        locations.append(Locations(name: "London", lat: 51.5074, long: 0.1278))
        locations.append(Locations(name: "Tokyo", lat: 35.6895, long: 139.6917))
        
        //drop location pins onto map:
        for location in locations {
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = CLLocationCoordinate2DMake(location.lat, location.long)
            dropPin.title = location.name
            mapView.addAnnotation(dropPin)
        }
        
        //create button to toggle pins:
        let pinButton = UIButton(type: .system)
        pinButton.setTitle("Pins", for: .normal)
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        pinButton.addTarget(self, action: #selector(selectPin(_:)), for: .touchUpInside)
        view.addSubview(pinButton)
        pinButton.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -8).isActive = true
        pinButton.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
    }
    
    //function call when button is pressed:
    @objc func selectPin(_ button: UIButton) {
        
        //data checks:
        if !(mapView.annotations.count > 0) {
            return
        }
        
        //go to next annotation or back to start if last one:
        selectedAnnotationIndex += 1
        if selectedAnnotationIndex >= mapView.annotations.count {
            selectedAnnotationIndex = 0
        }
        
        //select pin and animate map:
        let annotation = mapView.annotations[selectedAnnotationIndex]
        let zoomedInCurrentLocation = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(zoomedInCurrentLocation, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController loaded its view")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func initLocalizatinButton(_ anyView: UIView!) {
        let localizationButton = UIButton.init(type: .system)
        localizationButton.setTitle("Localization", for: .normal)
        localizationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(localizationButton)
        
        let topConstrains = localizationButton.topAnchor.constraint(equalToSystemSpacingBelow: anyView.topAnchor, multiplier: 32)
        let leadingConstraint = localizationButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor)
        let trailingConstraint = localizationButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        topConstrains.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        localizationButton.addTarget(self, action: #selector(MapViewController.showLocalization(sender:)), for: .touchUpInside)
    }
    
    @objc func showLocalization(sender: UIButton!) {
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let zoomInCurrentLocation = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(zoomInCurrentLocation, animated: true)
    }
}

struct Locations {
    var name: String
    var lat: Double
    var long: Double
    
    init(name: String, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}

