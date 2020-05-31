//
//  CurrentWeather.swift
//  
//
//  Created by Mason Phillips on 5/31/20.
//

import Foundation
import RxSwift

struct CurrentWeatherRequest: APIRequest {
    typealias Result = WeatherResponse
    
    var endpoint: String { return "/weather" }
    var parameters: Dictionary<String, String> {
        var dict: Dictionary<String, String> = [:]
        switch type {
        case .city(let n, let s, let c):
            var str = n.replacingOccurrences(of: " ", with: "+")
            if let s = s { str += ",\(s.replacingOccurrences(of: " ", with: "+"))" }
            if let c = c { str += ",\(c)" }
            dict = ["q": str]
        case .id(let id):
            dict = ["id": id]
        case .coordinates(let lat, let lon):
            dict = ["lat": "\(lat)", "lon": "\(lon)"]
        case .zip(let code):
            dict = ["zip": code]
        }
        
        switch unit {
        case .imperial: dict["units"] = "imperial"
        case .metric  : dict["units"] = "metric"
        default: break
        }
        
        return dict
    }
    
    var type: RequestType
    
    enum RequestType {
        case city(name: String, state: String?, country: String?)
        case id(id: String)
        case coordinates(lat: Double, lon: Double)
        case zip(code: String)
    }
    
    var unit: UnitType

    init(request: RequestType, unit: UnitType) {
        self.type = request
        self.unit = unit
    }
}

public enum UnitType {
    case imperial, metric, kelvin
}

public extension API {
    func currentWeather(city: String, state: String? = nil, country: String? = nil, unit: UnitType = .imperial) -> Single<WeatherResponse> {
        let request = CurrentWeatherRequest(request: .city(name: city, state: state, country: country), unit: unit)
        return _request(request)
    }
    
    func currentWeather(lat: Double, lon: Double, unit: UnitType = .imperial) -> Single<WeatherResponse> {
        let request = CurrentWeatherRequest(request: .coordinates(lat: lat, lon: lon), unit: unit)
        return _request(request)
    }
    
    func currentWeather(zip: String, unit: UnitType = .imperial) -> Single<WeatherResponse> {
        let request = CurrentWeatherRequest(request: .zip(code: zip), unit: unit)
        return _request(request)
    }
}

public struct WeatherResponse: Codable {
    public let coordinates: Coordinates
    public let weather    : [Weather]
    public let base       : String
    public let main       : Main
    public let wind       : Wind
    public let clouds     : Clouds
    public let rain       : Precipitation?
    public let snow       : Precipitation?
    public let datetime   : Int
    public let system     : System
    public let timezone   : Int
    public let id         : Int
    public let name       : String
    public let cod        : Int
    
    enum CodingKeys: String, CodingKey {
        case weather, base, main, wind, clouds, rain, snow, timezone, id, name, cod
        case coordinates = "coord"
        case datetime    = "dt"
        case system      = "sys"
    }
}

public struct Coordinates: Codable {
    public let latitude : Double
    public let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude  = "lat"
        case longitude = "lon"
    }
}

public struct Weather: Codable {
    public let id         : Int
    public let main       : String
    public let description: String
    public let icon       : String
}

public struct Main: Codable {
    public let temperature: Double
    public let feelsLike  : Double
    public let pressure   : Double
    public let humidity   : Double
    public let tempMin    : Double
    public let tempMax    : Double
    public let seaLevel   : Double?
    public let groundLevel: Double?
    
    enum CodingKeys: String, CodingKey {
        case pressure, humidity
        case temperature = "temp"
        case feelsLike   = "feels_like"
        case tempMin     = "temp_min"
        case tempMax     = "temp_max"
        case seaLevel    = "sea_level"
        case groundLevel = "grnd_level"
    }
}

public struct Wind: Codable {
    public let speed  : Float
    public let degrees: Float?
}

public struct Clouds: Codable {
    public let all: Int
}

public struct Precipitation: Codable {
    public let oneHour  : Float
    public let threeHour: Float
    
    enum CodingKeys: String, CodingKey {
        case oneHour   = "1h"
        case threeHour = "3h"
    }
}

public struct System: Codable {
    public let type   : Int
    public let id     : Int
    public let message: Float?
    public let country: String
    public let sunrise: Int
    public let sunset : Int
}
