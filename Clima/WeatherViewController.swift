//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController , CLLocationManagerDelegate , ChangeCityDelegate{
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    

    //TODO: Declare instance variables here
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
    
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
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
    //Write the updateWeatherData method here:
    

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
        temperatureLabel.text = "\(weatherDataModel.temperature)°"
        print("\(String(weatherDataModel.temperature)) \(weatherDataModel.city) \(weatherDataModel.condition) ")
        cityLabel.text = weatherDataModel.city
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
         let latitude = String(location.coordinate.latitude)
         let longitude = String(location.coordinate.longitude)
        
        print(latitude)
        print(longitude)
        
        let details : [String : String] = ["lat" : latitude , "lon" : longitude , "appid" : APP_ID]
        
        getWeatherData (appUrl : WEATHER_URL, parameters: details)
        
        
    }
    
    
    //Write the didFailWithError method here:
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
        print(error)
        cityLabel.text = "Location Unavailable"
    }

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    func cityNameEntered(city: String) {
        
        let params : [String:String] = ["q":city,"appid":APP_ID]
        getWeatherData(appUrl: WEATHER_URL, parameters: params)
    }
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeCityName" {
            
            let destination = segue.destination as! ChangeCityViewController
            
            destination.cityChangedDelegate = self
        }
    }
    
    
    
}


