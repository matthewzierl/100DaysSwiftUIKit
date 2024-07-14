import Foundation

struct VideoGame: Codable {
    var name: String
    var platforms: String
    var genres: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case platforms
        case genres
        case description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Handle name being either a string or an integer
        if let nameInt = try? container.decode(Int.self, forKey: .name) {
            name = String(nameInt)
        } else if let nameString = try? container.decode(String.self, forKey: .name) {
            name = nameString
        } else {
            name = "Unknown"
        }
        
        platforms = try container.decode(String.self, forKey: .platforms)
        genres = try container.decode(String.self, forKey: .genres)
        
        if let pulledDescription = try? container.decode(String.self, forKey: .description) {
            description = pulledDescription
        } else if let pulledDescription = try? container.decode(Int.self, forKey: .description) {
            description = String(pulledDescription)
        } else {
            description = "Unknown"
        }
    }
}
