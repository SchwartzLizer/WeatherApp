//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Tanatip Denduangchai on 7/29/20.
//  Copyright © 2020 Tanatip Denduangchai. All rights reserved.
//


import Foundation

struct WeatherData: Codable {
    let name:String
    let main:main
    let weather:[weather]
}
struct main : Codable {
    let temp : Double
}

struct weather : Codable {
    let id:Int
    let description:String
}
