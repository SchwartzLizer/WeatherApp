//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Tanatip Denduangchai on 7/29/20.
//  Copyright © 2020 Tanatip Denduangchai. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchLabel: UITextField!
    
    var weatherManager = openWeatherAPI() //call struct from weather manager to this class
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchLabel.delegate = self //Use delegate UITEXTField to controller this class
        weatherManager.delegate = self
        
    }

    @IBAction func searchButton(_ sender: UIButton) {   //Return with Search Button
        searchLabel.endEditing(true) //dismiss keyboard when end
        print(searchLabel.text!)
    }
    @IBAction func GPSbutton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { //return with return keyboard
        searchLabel.endEditing(true)//dismiss keyboard when end
        print(searchLabel.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool { //when user press Search textfield but didn't do anything
        if textField.text != "" {
            return true } //didn't do
        else {
            textField.placeholder = "Type Something"
            return false //replace placeholder to Type Something
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchLabel.text {    //create var city = input
            weatherManager.fetchWeather(cityName: city) //var city add in func fetchWeather
            cityLabel.text = city
        }
        searchLabel.text = "" //when already input text field will be clear
        textField.placeholder = "Search"
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: openWeatherAPI, weather: weatherModel){ //parse WeatherModel to here
        DispatchQueue.main.async { //wait network to get api data if not this will be crash
            self.temperatureLabel.text = weather.temperatureString
            print(weather.cityname)
            print(weather.conditionName)
            print(weather.temperatureString)
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityname
            
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation() //clear old location will get new
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat,longitude: lon)
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

