import UIKit

func getHaterStatus(weather: String) -> String? {
    if weather == "sunny" {
        return nil
    } else {
        return "Hate"
    }
}

var status: String

if let status = getHaterStatus(weather: "rainy") {
    print(status)
}


enum WeatherType {
    case sun
    case cloud
    case rain
    case wind(speed: Int)
    case snow
}
func getWeatherHaterStatus(weather: WeatherType) -> String? {
    switch weather {
    case .sun:
        return nil
    case .wind(let speed) where speed < 10: // using speed attribute for wind
        return "meh"
    case .cloud, .wind:
        return "dislike"
    case .rain, .snow:
        return "hate"
    }
}

if let response = getWeatherHaterStatus(weather: WeatherType.wind(speed: 5)) {
    print(response)
}

struct Person {
    var name: String
    var clothes: String
}
var matt = Person(name: "matt", clothes: "boots")

