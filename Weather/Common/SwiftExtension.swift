//
//  SwiftExtension.swift
//  Weather
//
//  Created by Studio-SJ on 2022/10/05.
//
import SwiftUI
import Combine

extension Int {
    func getDate() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "MM월 dd일"
        
        let kr = date.string(from: timeToDate)
        return kr
    }

    func getTime() -> String {
        let timeToDate = Date(timeIntervalSince1970: Double(self)) // 2021-10-13 17:16:15 +0000
        let date = DateFormatter()
        date.locale = Locale(identifier: "ko_kr")
        date.timeZone = TimeZone(abbreviation: "KST") // "2018-03-21 18:07:27"
        date.dateFormat = "HH시 mm분"
        
        let kr = date.string(from: timeToDate)
        return kr
    }
    
    func getDateAndTime() -> String {
        return "\(self.getDate())  \(self.getTime())"
    }
}

extension Double {
    func KelToCel() -> String {
        return String(format: "%0.1f°", (self - 273.15))
    }
    
    func windSpeed() -> String {
        return "\(self)"
    }
    
    func pop() -> String {
        return String(format: "%0.1f%", self)
    }
}

extension String {
    func weatherType() -> WeatherType {
        switch self {
        case "01d","01n": return .clearSky
        case "02d","02n": return .fewClouds
        case "03d","03n": return .scatteredClouds
        case "04d","04n": return .brokenClouds
        case "09d","09n": return .showerRain
        case "10d","10n": return .rain
        case "11d","11n": return .thunderStorm
        case "13d","13n": return .snow
        case "50d","50n": return .mist
        default: return .unknown
        }
    }
}
extension Publisher {
    func run(in set: inout Set<AnyCancellable>, next: ((Self.Output) -> Void)? = nil, err errorListener: ((Error) -> Void)? = nil, complete: (() -> Void)? = nil) {
        self.subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(err) = completion {
                    errorListener?(err)
                }
                complete?()
            } receiveValue: { value in
                next?(value)
            }
            .store(in: &set)
    }
}

extension View {
    public func border(_ color: Color, lineWidth: CGFloat, cornerRadius: CGFloat) -> some View {
        return self
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: lineWidth).foregroundColor(color))
    }
    
    public func frame(both: CGFloat, aligment: Alignment = .center) -> some View {
        return self
            .frame(width: both, height: both, alignment: aligment)
    }
}

extension Color {
    init(hex string: String, opacity: CGFloat? = nil) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }
        
        // Double the last value if incomplete hex
        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }
        
        // Fix invalid values
        if string.count > 8 {
            string = String(string.prefix(8))
        }
        
        // Scanner creation
        let scanner = Scanner(string: string)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        if string.count == 2 {
            let mask = 0xFF
            let g = Int(color) & mask
            let gray = Double(g) / 255.0
            
            
            if let opacity = opacity {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: opacity)
            } else {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
            }
        } else if string.count == 4 {
            let mask = 0x00FF
            
            let g = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: opacity)
            } else {
                self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
            }
        } else if string.count == 6 {
            let mask = 0x0000FF
            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
            } else {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
            }
            
        } else if string.count == 8 {
            let mask = 0x000000FF
            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask
            
            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0
            
            if let opacity = opacity {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
            } else {
                self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
            }
            
        } else {
            self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
        }
    }
    
    var uiColor: UIColor {
        get { UIColor(cgColor: cgColor!) }
    }
    public static let clearSky60: Color = Color(hex: "#78D7FF", opacity: 0.4)
    public static let fewClouds60: Color = Color(hex: "#76A5FF", opacity: 0.4)
    public static let scatteredClouds60: Color = Color(hex: "#4971FF", opacity: 0.4)
    public static let brokenClouds60: Color = Color(hex: "#42339B", opacity: 0.4)
    public static let showerRain60: Color = Color(hex: "#53FFC1", opacity: 0.4)
    public static let rain60: Color = Color(hex: "#FFB629", opacity: 0.4)
    public static let thunderStorm60: Color = Color(hex: "#907DFF", opacity: 0.4)
    public static let snow60: Color = Color(hex: "#FFFFFF", opacity: 0.4)
    public static let mist60: Color = Color(hex: "#B9B9B9", opacity: 0.4)
    public static let unknown60: Color = Color(hex: "#76A5FF", opacity: 0.4)
    
    public static let mint100: Color = Color(hex: "#1ED8C5")
    public static let orange100: Color = Color(hex: "#FF752F")
    
    public static let lightblue100: Color = Color(hex: "#78D7FF")
    public static let lightblue80: Color = Color(hex: "#78D7FF", opacity: 0.8)
    public static let lightblue60: Color = Color(hex: "#78D7FF", opacity: 0.6)
    public static let darkblue100: Color = Color(hex: "#1875FF")
    public static let darkblue80: Color = Color(hex: "#1875FF", opacity: 0.8)
    public static let darkblue60: Color = Color(hex: "#1875FF", opacity: 0.6)
    public static let blue100: Color = Color(hex: "#15B9FF")
    public static let blue80: Color = Color(hex: "#15B9FF", opacity: 0.8)
    public static let blue60: Color = Color(hex: "#15B9FF", opacity: 0.6)
    public static let red100: Color = Color(hex: "#FF4C24")
    public static let red80: Color = Color(hex: "#FF4C24", opacity: 0.8)
    public static let red60: Color = Color(hex: "#FF4C24", opacity: 0.6)
    public static let yellow100: Color = Color(hex: "#FFD027")
    public static let yellow80: Color = Color(hex: "#FFD027", opacity: 0.8)
    public static let yellow60: Color = Color(hex: "#FFD027", opacity: 0.6)
    
    public static let gray100: Color = Color(hex: "#454545")
    public static let gray90: Color = Color(hex: "#454B52")
    public static let gray60: Color = Color(hex: "#454545", opacity: 0.6)
    public static let gray50: Color = Color(hex: "#454545", opacity: 0.5)
    public static let gray30: Color = Color(hex: "#454545", opacity: 0.3)
    public static let lightGray01: Color = Color(hex: "#E8E8E8")
    public static let lightGray02: Color = Color(hex: "#EAEDF0")
    public static let lightGray03: Color = Color(hex: "#F8F8F8")
    
    public static let dim: Color = Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.6)
}

extension UIColor {
    convenience init(hex: String, opacity: CGFloat? = nil) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            _ = hex.removeFirst()
        }
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        if let opacity = opacity {
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: opacity)
        } else {
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    }
    
    public static let clearSky60: UIColor = UIColor(hex: "#78D7FF", opacity: 0.4)
    public static let fewClouds60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)
    public static let scatteredClouds60: UIColor = UIColor(hex: "#4971FF", opacity: 0.4)
    public static let brokenClouds60: UIColor = UIColor(hex: "#42339B", opacity: 0.4)
    public static let showerRain60: UIColor = UIColor(hex: "#53FFC1", opacity: 0.4)
    public static let rain60: UIColor = UIColor(hex: "#FFB629", opacity: 0.4)
    public static let thunderStorm60: UIColor = UIColor(hex: "#907DFF", opacity: 0.4)
    public static let snow60: UIColor = UIColor(hex: "#FFFFFF", opacity: 0.4)
    public static let mist60: UIColor = UIColor(hex: "#B9B9B9", opacity: 0.4)
    public static let unknown60: UIColor = UIColor(hex: "#76A5FF", opacity: 0.4)
    
    public static let mint100: UIColor = UIColor(hex: "#1ED8C5")
    public static let orange100: UIColor = UIColor(hex: "#FF752F")
    
    public static let lightblue100: UIColor = UIColor(hex: "#78D7FF")
    public static let lightblue80: UIColor = UIColor(hex: "#78D7FF", opacity: 0.8)
    public static let lightblue60: UIColor = UIColor(hex: "#78D7FF", opacity: 0.6)
    public static let darkblue100: UIColor = UIColor(hex: "#1875FF")
    public static let darkblue80: UIColor = UIColor(hex: "#1875FF", opacity: 0.8)
    public static let darkblue60: UIColor = UIColor(hex: "#1875FF", opacity: 0.6)
    public static let blue100: UIColor = UIColor(hex: "#15B9FF")
    public static let blue80: UIColor = UIColor(hex: "#15B9FF", opacity: 0.8)
    public static let blue60: UIColor = UIColor(hex: "#15B9FF", opacity: 0.6)
    public static let red100: UIColor = UIColor(hex: "#FF4C24")
    public static let red80: UIColor = UIColor(hex: "#FF4C24", opacity: 0.8)
    public static let red60: UIColor = UIColor(hex: "#FF4C24", opacity: 0.6)
    public static let yellow100: UIColor = UIColor(hex: "#FFD027")
    public static let yellow80: UIColor = UIColor(hex: "#FFD027", opacity: 0.8)
    public static let yellow60: UIColor = UIColor(hex: "#FFD027", opacity: 0.6)
    
    public static let gray100: UIColor = UIColor(hex: "#454545")
    public static let gray90: UIColor = UIColor(hex: "#454B52")
    public static let gray60: UIColor = UIColor(hex: "#454545", opacity: 0.6)
    public static let gray50: UIColor = UIColor(hex: "#454545", opacity: 0.5)
    public static let gray30: UIColor = UIColor(hex: "#454545", opacity: 0.3)
    public static let lightGray01: UIColor = UIColor(hex: "#E8E8E8")
    public static let lightGray02: UIColor = UIColor(hex: "#EAEDF0")
    public static let lightGray03: UIColor = UIColor(hex: "#F8F8F8")
    
    public static let dim: UIColor = .init(red: 0, green: 0, blue: 0, alpha: 0.6) //UIColor(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.6)
}

extension Font {
    public static let kr30b: Font = .system(size: 30, weight: .bold, design: .default)
    public static let kr30r: Font = .system(size: 30, weight: .regular, design: .default)
    
    public static let kr26b: Font = .system(size: 26, weight: .bold, design: .default)
    public static let kr26r: Font = .system(size: 26, weight: .regular, design: .default)
    
    public static let kr20b: Font = .system(size: 20, weight: .bold, design: .default)
    public static let kr20r: Font = .system(size: 20, weight: .regular, design: .default)
    
    public static let kr19b: Font = .system(size: 19, weight: .bold, design: .default)
    public static let kr19r: Font = .system(size: 19, weight: .regular, design: .default)
    
    public static let kr18b: Font = .system(size: 18, weight: .bold, design: .default)
    public static let kr18r: Font = .system(size: 18, weight: .regular, design: .default)
    
    public static let kr16b: Font = .system(size: 16, weight: .bold, design: .default)
    public static let kr16r: Font = .system(size: 16, weight: .regular, design: .default)
    
    public static let kr15b: Font = .system(size: 15, weight: .bold, design: .default)
    public static let kr15r: Font = .system(size: 15, weight: .regular, design: .default)
    
    public static let kr14b: Font = .system(size: 14, weight: .bold, design: .default)
    public static let kr14r: Font = .system(size: 14, weight: .regular, design: .default)
    
    public static let kr13b: Font = .system(size: 13, weight: .bold, design: .default)
    public static let kr13r: Font = .system(size: 13, weight: .regular, design: .default)
    
    public static let kr12b: Font = .system(size: 12, weight: .bold, design: .default)
    public static let kr12r: Font = .system(size: 12, weight: .regular, design: .default)
    
    public static let kr11b: Font = .system(size: 11, weight: .bold, design: .default)
    public static let kr11r: Font = .system(size: 11, weight: .regular, design: .default)
    
    public static let kr9r: Font = .system(size: 9, weight: .regular, design: .default)
}

extension UIFont {
    public static let kr30b: UIFont = .systemFont(ofSize: 30, weight: .bold)
    public static let kr30r: UIFont = .systemFont(ofSize: 30, weight: .regular)
    
    public static let kr26b: UIFont = .systemFont(ofSize: 26, weight: .bold)
    public static let kr26r: UIFont = .systemFont(ofSize: 26, weight: .regular)
    
    public static let kr20b: UIFont = .systemFont(ofSize: 20, weight: .bold)
    public static let kr20r: UIFont = .systemFont(ofSize: 20, weight: .regular)
    
    public static let kr19b: UIFont = .systemFont(ofSize: 19, weight: .bold)
    public static let kr19r: UIFont = .systemFont(ofSize: 19, weight: .regular)
    
    public static let kr18b: UIFont = .systemFont(ofSize: 18, weight: .bold)
    public static let kr18r: UIFont = .systemFont(ofSize: 18, weight: .regular)
    
    public static let kr16b: UIFont = .systemFont(ofSize: 16, weight: .bold)
    public static let kr16r: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    public static let kr15b: UIFont = .systemFont(ofSize: 15, weight: .bold)
    public static let kr15r: UIFont = .systemFont(ofSize: 15, weight: .regular)
    
    public static let kr14b: UIFont = .systemFont(ofSize: 14, weight: .bold)
    public static let kr14r: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    public static let kr13b: UIFont = .systemFont(ofSize: 13, weight: .bold)
    public static let kr13r: UIFont = .systemFont(ofSize: 13, weight: .regular)
    
    public static let kr12b: UIFont = .systemFont(ofSize: 12, weight: .bold)
    public static let kr12r: UIFont = .systemFont(ofSize: 12, weight: .regular)
    
    public static let kr11b: UIFont = .systemFont(ofSize: 11, weight: .bold)
    public static let kr11r: UIFont = .systemFont(ofSize: 11, weight: .regular)
    
    public static let kr9r: UIFont = .systemFont(ofSize: 9, weight: .regular)
}

extension Bundle {
    // 생성한 .plist 파일 경로 불러오기
    var WEATHER_API_KEY: String? {
        return self.infoDictionary?["WEATHER_API_KEY"] as? String ?? nil
    }
}
