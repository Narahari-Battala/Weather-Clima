//
//  ViewController.swift
//  WeatherApp
//
//  Created by Narahari Battala on 03/28/2018.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
/*
     This class contains methods for getting the weather data , parsing the data and displaying the results on user
     Interface
 */
class WeatherViewController: UIViewController , CLLocationManagerDelegate , ChangeCityDelegate{
    
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    // This Method gets the weather data using the location details
    
    func getWeatherData(appUrl:String,parameters:[String:String]) {
        
        Alamofire.request(appUrl, method: .get, parameters: parameters) . responseJSON {
            response in
            if response.result.isSuccess {
                let result:JSON = JSON(response.result.value!)
                self.parseJson(data: result)
            }
            else {
                print("failure")
            }
        }
        
    }
    

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    func parseJson(data:JSON){
        
        if let temp = data["main"]["temp"].double {
            
        weatherDataModel.temperature = Int(temp - 273.15)
        let name = data["name"].stringValue
        weatherDataModel.city = name
        let weather = data["weather"][0]["id"]
        weatherDataModel.condition = weather.intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUIWithWeatherData()
            
        }
        
        else {
            print("unavaila")
            cityLabel.text = "Location Unavailable"
        }
        
    }
    
    //This methods is for UI Updates
    
    func updateUIWithWeatherData() {
        
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        print("\(String(weatherDataModel.temperature)) \(weatherDataModel.city) \(weatherDataModel.condition) ")
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    //This methods gets the current location details
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
         let latitude = String(location.coordinate.latitude)
         let longitude = String(location.coordinate.longitude)
        
        let details : [String : String] = ["lat" : latitude , "lon" : longitude , "appid" : APP_ID]
        
        getWeatherData (appUrl : WEATHER_URL, parameters: details)
        
        
    }
    
    
    //This methods executes when location is unavailable
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        cityLabel.text = "Location Unavailable"
    }

    
    //This methods is used to get the weather data based on city name
    
    func cityNameEntered(city: String) {
        
        let params : [String:String] = ["q":city,"appid":APP_ID]
        getWeatherData(appUrl: WEATHER_URL, parameters: params)
    }
    

    
   // This method sets the delegate of ChangeCityDelegate protocal to current class
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destination = segue.destination as! ChangeCityViewController
            
            destination.cityChangedDelegate = self
        }
    }
    
    
    
}


