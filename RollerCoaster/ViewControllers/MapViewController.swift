//
//  MapViewController.swift
//  Divyesh karansinh Solanki
//  student id: 301194819
//  date created : 26/03/2022

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet weak var lblLocation: UILabel!
    var locationManager:CLLocationManager!
    var currentLocationStr = "Current location"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //MARK:- CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let mUserLocation:CLLocation = locations[0] as CLLocation
        let center = CLLocationCoordinate2D(latitude: mUserLocation.coordinate.latitude, longitude: mUserLocation.coordinate.longitude)
        let mRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mMapView.setRegion(mRegion, animated: true)
        
        // Get user's Current Location and Drop a pin
        self.setUsersClosestLocation(mLattitude: mUserLocation.coordinate.latitude, mLongitude: mUserLocation.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    //MARK:- Intance Methods
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setUsersClosestLocation(mLattitude: CLLocationDegrees, mLongitude: CLLocationDegrees) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: mLattitude, longitude: mLongitude)
        
        geoCoder.reverseGeocodeLocation(location) {
            (placemarks, error) -> Void in
            
            if let mPlacemark = placemarks {
                if let dict = mPlacemark.first?.addressDictionary as? [String: Any]{
                    if let elements = dict["FormattedAddressLines"] as? [String] {
                        self.currentLocationStr = elements.joined(separator: ", ")
                        self.mMapView.removeAnnotations(self.mMapView.annotations)
                        self.setLocationMarker(mUserLocation: location, title: self.currentLocationStr)
                        self.lblLocation.text = self.currentLocationStr
                        self.getNearByCasinos(mUserLocation: location)
                    }
                }
            }
        }
    }
    
    func getNearByCasinos(mUserLocation: CLLocation) {
        performGooglePlacesAPI(coordinate: mUserLocation.coordinate, keyword: "") { places, message in
            DispatchQueue.main.async {
                for row in places {
                    if let obj = row as? [String: Any], let lat = obj[kPlaceLatitude] as? Double, let lng = obj[kPlaceLongitude] as? Double {
                        let place = "\(obj[kPlaceName] as? String ?? "")\n\(obj[kPlaceAddress] as? String ?? "")"
                        self.setLocationMarker(mUserLocation: CLLocation(latitude: lat, longitude: lng), title: place)
                    }
                }
            }
        }
    }
    
    func setLocationMarker(mUserLocation: CLLocation, title: String?) {
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(mUserLocation.coordinate.latitude, mUserLocation.coordinate.longitude)
        mkAnnotation.title = title
        mMapView.addAnnotation(mkAnnotation)
    }
    
    //MARK:- Actions
    @IBAction private func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

let API_KEY : String = "AIzaSyAGYVmvijzmjC3dMX1yeM9RzMH6BiuPkx4"
let kPlaceId                    : String = "place_id"
let kPlaceAddress               : String = "vicinity"
let kPlaceFullAddress           : String = "formattedAddress"
let kPlaceFormattedAddress      : String = "formatted_address"
let kPlaceName                  : String = "name"
let kPlaceLatitude              : String = "lat";
let kPlaceLongitude             : String = "lng";
let kPlaceSataticImage          : String = "static_image";
let kPlaceIcon                  : String = "icon";

extension MapViewController {
    //MARK: - Google Place API
    ///Performs google place API to search for places
    func performGooglePlacesAPI(coordinate : CLLocationCoordinate2D?, keyword : String = "", completion : ((_ placesArray : NSMutableArray, _ message : String) -> Void)?)
    {
        let latitude = String(coordinate?.latitude ?? 0.0);
        let longitude = String(coordinate?.longitude ?? 0.0);
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=5000&type=&keyword=\(keyword)&key=\(API_KEY)";
        print(url)
        var request = URLRequest(url: URL(string: url)!);
        request.httpMethod = "GET";
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let session = URLSession.shared;
        let task = session.dataTask(with: request) { (data, response, error) in
            let arrayOfPlaces = NSMutableArray();
            if error == nil
            {
                do
                {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    {
                        if let results = jsonObject["results"] as? NSArray
                        {
                            for object in results
                            {
                                let objPlace = object as! NSDictionary
                                let placeDict = NSMutableDictionary();
                                
                                if let geometry = objPlace.value(forKey: "geometry") as? NSDictionary
                                {
                                    if let loc = geometry.value(forKey: "location") as? NSDictionary
                                    {
                                        placeDict.setValue(loc[kPlaceLatitude], forKey: kPlaceLatitude)
                                        placeDict.setValue(loc[kPlaceLongitude], forKey: kPlaceLongitude)
                                    }
                                    else
                                    {
                                        placeDict.setValue(0.0, forKey: kPlaceLatitude)
                                        placeDict.setValue(0.0, forKey: kPlaceLongitude)
                                    }
                                }
                                else
                                {
                                    placeDict.setValue(0.0, forKey: kPlaceLatitude)
                                    placeDict.setValue(0.0, forKey: kPlaceLongitude)
                                }
                                placeDict.setValue(objPlace[kPlaceId], forKey: kPlaceId);
                                placeDict.setValue(objPlace[kPlaceIcon], forKey: kPlaceIcon);
                                placeDict.setValue(objPlace[kPlaceName], forKey: kPlaceName);
                                placeDict.setValue(objPlace[kPlaceAddress], forKey: kPlaceAddress);
                                arrayOfPlaces.add(placeDict);
                            }
                            completion!(arrayOfPlaces, "success");
                        }
                        else
                        {
                            completion?(arrayOfPlaces, "No Places found");
                        }
                    }
                    else
                    {
                        print("CANNOT PARSE RESULTS");
                    }
                }
                catch let expError
                {
                    print("PARSING ERROR : \(expError.localizedDescription)");
                    completion?(arrayOfPlaces, expError.localizedDescription)
                }
            }
            else
            {
                completion?(arrayOfPlaces, (error?.localizedDescription)!)
            }
        }
        task.resume();
    }
}
