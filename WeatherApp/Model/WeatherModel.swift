//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Tanatip Denduangchai on 7/29/20.
//  Copyright © 2020 Tanatip Denduangchai. All rights reserved.
//

import Foundation

struct weatherModel {
    let ID: Int
    let cityname : String
    let temperature:Double
    
    var temperatureString: String {
        return String(format: "%.1f" , temperature)
    }
    
    var conditionName: String{
        switch ID {
           case 200...232:
               return "cloud.bolt"
           case 300...321:
               return "cloud.drizzle"
           case 500...531:
               return "cloud.rain"
           case 500...531:
               return "cloud.snow"
           case 500...531:
               return "cloud.fox"
           case 500...531:
               return "sun.max"
           case 500...531:
               return "cloud.bolt"
           default:
               return "cloud"
           }
    }
}
