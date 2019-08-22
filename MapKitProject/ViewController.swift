//
//  ViewController.swift
//  MapKitProject
//
//  Created by iSal on 19/08/19.
//  Copyright © 2019 iSal. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        checkLocationServices()
        setupPins()
        registerAnnotationViews()
    }
    
    private func registerAnnotationViews() {
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(CustomPin.self))
    }
    
    func setupPins() {
        let location1 = CLLocationCoordinate2D(latitude:  -6.302651, longitude: 106.652595)
        let pin1 = CustomPin(pinTitle: "Pin1", pinSubTitle: "Nothing's Here", location: location1, isVictim: true)
        mapView.addAnnotation(pin1)
        
        let location2 = CLLocationCoordinate2D(latitude:  -6.302464, longitude: 106.651259)
        let pin2 = CustomPin(pinTitle: "Pin2", pinSubTitle: "Nothing's Here", location: location2, isVictim: false)
        mapView.addAnnotation(pin2)
        
    }
    func centerViewLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    func setupLoactionManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            // setup our location manager
            setupLoactionManager()
            checkLocationAuth()
        } else {
            print("is disabled")
        }
    }
    func checkLocationAuth(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            mapView.showsCompass = true
            mapView.showsPointsOfInterest = true
            centerViewLocation()
        case .authorizedAlways:
            break
        case .denied:
            break
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            centerViewLocation()
        @unknown default:
            fatalError()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = NSStringFromClass(CustomPin.self)
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        let rightButton = UIButton(type: .infoDark)
        annotationView?.rightCalloutAccessoryView = rightButton
        if let annotation = annotation as? CustomPin {
            var img:UIImage!
            if annotation.isVictim {
                 img = UIImage(named: "pin1")
            } else {
                img = UIImage(named: "pin2")
            }
            annotationView?.image = img
            let offset = CGPoint(x: img.size.width / 2, y: -(img.size.height / 2) )
            annotationView?.centerOffset = offset
        }
        
        
        annotationView?.canShowCallout = true
        return annotationView
    }
}


class CustomPin:NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var isVictim: Bool!
    
    init(pinTitle: String, pinSubTitle: String, location: CLLocationCoordinate2D, isVictim: Bool) {
        coordinate = location
        title = pinTitle
        subtitle = pinSubTitle
        self.isVictim = isVictim
    }
}
