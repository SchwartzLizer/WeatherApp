//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Tanatip Denduangchai on 7/29/20.
//  Copyright © 2020 Tanatip Denduangchai. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate { // delegate WeatherViewController <--Talk--> Weather Manager
    func didUpdateWeather(_ weatherManager: openWeatherAPI, weather: weatherModel)
    func didFailWithError(error: Error)
}

struct openWeatherAPI {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=f08587555d1716d75e3466420948adb6&units=metric" //API URL
    // APPID = create account openweather and get api
    // units = metric system or US system
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName : String) {
        let location = "\(weatherURL)&q=\(cityName)" // API + City URL
        performRequest(with: location)    //send location to function performRequest with var action
        
    }
    
    func fetchWeather (latitude: CLLocationDegrees , longitude : CLLocationDegrees){
        let location = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: location)
    }
    
    func performRequest(with action : String) { //Create function to get weather data
        //1.create url
        if let url = URL(string: action){ // get url from
            //2.create Session
            let session = URLSession(configuration: .default) //create var session to create session and config default
            //3.Create Task
            let task = session.dataTask(with: url) { (Data, URLResponse, error) in //Closure Function Handler
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = Data { //safeData Type : data
                    if let weather = self.parseJSON(safeData) { // if download finish will parse to weatherData
                        self.delegate?.didUpdateWeather(self, weather: weather)// parse to ViewController
                    }
                    
                    /*let convertSafeData = String(data: safeData, encoding: .utf8) // convert Type data to String
                    print(convertSafeData!)*/ // print for check data can be download
                }
                
            }
            //4.start the task
            task.resume()
        }
            
        }
    func parseJSON(_ weatherData: Data) -> weatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) //decode weatherdata (init) from weatherdata.swift to mapping with weather data from performRequest is get from api
            let id = decodedData.weather[0].id //[0]select first item in array
            let temp = decodedData.main.temp
            let name = decodedData.name
           // let description = decodedData.weather[1].description
            
            let weather = weatherModel.init(ID: id, cityname: name, temperature: temp)//create object swift
            return weather
        }
        catch {//when error
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
