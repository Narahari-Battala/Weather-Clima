//
//  ChangeCityViewController.swift
//  WeatherApp
//
//  Created by Narahari Battala on 03/28/2018.
//

import UIKit

protocol  ChangeCityDelegate {
    
    func cityNameEntered(city:String)
}

/* This class is used to get the weather details based on city name , the city name can be accessed by the
   WeatherViewController class with the help of above protocol . The city name will be used to get the weather details
 */

class ChangeCityViewController: UIViewController {
    
    var cityChangedDelegate:ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        let changedCity = changeCityTextField.text!
    
        cityChangedDelegate?.cityNameEntered(city: changedCity)

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
