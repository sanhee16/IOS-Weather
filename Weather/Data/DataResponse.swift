//
//  DataResponse.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//

import Foundation

//MARK: Weather
public struct WeatherResponse: Codable {
    var current: Current // Current
    var daily: [Daily] // Weekly
    
    enum CodingKeys: String, CodingKey {
        case current
        case daily
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current = try values.decode(Current.self, forKey: .current)
        daily = try values.decode([Daily].self, forKey: .daily)
    }
}


public struct Weather: Codable {
    var id: Int // 날씨 코드
    var main: String // main 날씨
    var description: String // 날씨 설명, kr
    var icon: String // 아이콘 코드
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case description
        case icon
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        main = try values.decode(String.self, forKey: .main)
        description = try values.decode(String.self, forKey: .description)
        icon = try values.decode(String.self, forKey: .icon)
    }
}

public struct Current: Codable {
    var dt: Int // 현재 시간
    var sunrise: Int // 일출 UTC
    var sunset: Int // 일몰 UTC
    var temp: Double // 현재 온도
    var pressure: Int // 기압
    var feels_like: Double // 체감 온도
    var humidity: Int // 습도 %
    var uvi: Double // 현재 자외선 지수
    var clouds: Int // 흐림 %
    var windSpeed: Double // 바람의 속도. 단위 – 기본값: 미터/초
    var weather: [Weather]

    
    enum CodingKeys: String, CodingKey {
        case dt
        case sunrise
        case sunset
        case temp
        case pressure
        case feels_like
        case humidity
        case uvi
        case clouds
        case windSpeed = "wind_speed"
        case weather
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decode(Int.self, forKey: .dt)
        sunrise = try values.decode(Int.self, forKey: .sunrise)
        sunset = try values.decode(Int.self, forKey: .sunset)
        temp = try values.decode(Double.self, forKey: .temp)
        pressure = try values.decode(Int.self, forKey: .pressure)
        feels_like = try values.decode(Double.self, forKey: .feels_like)
        humidity = try values.decode(Int.self, forKey: .humidity)
        uvi = try values.decode(Double.self, forKey: .uvi)
        clouds = try values.decode(Int.self, forKey: .clouds)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        weather = try values.decode([Weather].self, forKey: .weather)
    }
}


// [필수] 지역 이름, 날씨 아이콘, 날씨 설명, 현재 기온, 현재 습도, 오늘의 최고/최저 기온
// [선택] 날짜, 업데이트 기준 시각, 현재 체감 기온, 미세먼지, 기압, 풍속, 하루 시간대별 날씨, 시간대별 강수 확률, 일주일 날씨
public struct Temp: Codable {
    var min: Double // 최저 기온
    var max: Double // 최고 기온
    
    enum CodingKeys: String, CodingKey {
        case min
        case max
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        min = try values.decode(Double.self, forKey: .min)
        max = try values.decode(Double.self, forKey: .max)
    }
}

public struct Daily: Codable {
    var dt: Int // 시간
    var temp: Temp // 온도 정보
    var windSpeed: Double // 바람의 속도. 단위 – 기본값: 미터/초
    var weather: [Weather]
    var pop: Double // 강수확률
    
    enum CodingKeys: String, CodingKey {
        case dt
        case temp
        case windSpeed = "wind_speed"
        case weather
        case pop
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decode(Int.self, forKey: .dt)
        temp = try values.decode(Temp.self, forKey: .temp)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
        weather = try values.decode([Weather].self, forKey: .weather)
        pop = try values.decode(Double.self, forKey: .pop)
    }
}

//MARK: 3 hours in 5 days

public struct ThreeHourlyResponse: Codable {
    var list: [ThreeHourly]
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decode([ThreeHourly].self, forKey: .list)
    }
}

public struct ThreeHourly: Codable {
    var dt: Int // 시간
    var main: ThreeHourlyTemp // 온도 정보
    var wind: ThreeHourlyWind
    var weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt
        case main
        case wind
        case weather
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decode(Int.self, forKey: .dt)
        main = try values.decode(ThreeHourlyTemp.self, forKey: .main)
        wind = try values.decode(ThreeHourlyWind.self, forKey: .wind)
        weather = try values.decode([Weather].self, forKey: .weather)
    }
}

public struct ThreeHourlyWind: Codable {
    var windSpeed: Double // 풍소
    
    enum CodingKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        windSpeed = try values.decode(Double.self, forKey: .windSpeed)
    }
}

public struct ThreeHourlyTemp: Codable {
    var temp: Double // 기온
    var min: Double // 최저 기온
    var max: Double // 최고 기온
    
    enum CodingKeys: String, CodingKey {
        case temp
        case min = "temp_min"
        case max = "temp_max"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decode(Double.self, forKey: .temp)
        min = try values.decode(Double.self, forKey: .min)
        max = try values.decode(Double.self, forKey: .max)
    }
}



/*
 "dt": 1665414000,
 "main": {
     "temp": 8.96,
     "feels_like": 6.04,
     "temp_min": 8.83,
     "temp_max": 8.96,
     "pressure": 1015,
     "sea_level": 1015,
     "grnd_level": 1013,
     "humidity": 71,
     "temp_kf": 0.13
 },
 "weather": [
     {
         "id": 803,
         "main": "Clouds",
         "description": "튼구름",
         "icon": "04n"
     }
 ],
 "clouds": {
     "all": 60
 },
 "wind": {
     "speed": 5.65,
     "deg": 297,
     "gust": 11.36
 },
 "visibility": 10000,
 "pop": 0,
 "sys": {
     "pod": "n"
 },
 "dt_txt": "2022-10-10 15:00:00"
 */


//MARK: firebase 는 json 필요 없음
public struct Board {
    var type: Int
    var text: String
    var createdAt: Int
}

extension Board {
    func getDate() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self.createdAt)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "MM월 dd일 HH:mm"
        return date.string(from: timeToDate)
    }
    
    func getWeatherType() -> WeatherType {
        return self.type.getWeatherType()
    }
}
