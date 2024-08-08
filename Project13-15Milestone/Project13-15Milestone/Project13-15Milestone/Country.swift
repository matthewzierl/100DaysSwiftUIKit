//
//  Country.swift
//  Project13-15Milestone
//
//  Created by Matthew Zierl on 8/8/24.
//

import Foundation

struct Country: Codable {
        
    let introduction: Introduction
    let geography: Geography
    let peopleAndSociety: PeopleAndSociety
    let government: Government
        
    enum CodingKeys: String, CodingKey { // mapping between struct members and raw value of json
        case introduction = "Introduction"
        case geography = "Geography"
        case peopleAndSociety = "People and Society"
        case government = "Government"
    }
    
    struct Introduction: Codable {
        let background: TextField
        
        enum CodingKeys: String, CodingKey {
            case background = "Background"
        }
    }
    
    struct Geography: Codable {
        let location: TextField
        let climate: TextField
        let terrain: TextField
        
        enum CodingKeys: String, CodingKey {
            case location = "Location"
            case climate = "Climate"
            case terrain = "Terrain"
        }
    }
    
    struct PeopleAndSociety: Codable {
        let population: Population
        
        enum CodingKeys: String, CodingKey {
            case population = "Population"
        }
    }
    
    struct Population: Codable {
        let total: TextField
        let male: TextField
        let female: TextField
        
        enum CodingKeys: String, CodingKey {
            case total = "total"
            case male = "male"
            case female = "female"
        }
    }
    
    struct Government: Codable {
        let countryName: CountryName
        let governmentType: TextField
        let capital: Capital
        
        enum CodingKeys: String, CodingKey {
            case countryName = "Country name"
            case governmentType = "Government type"
            case capital = "Capital"
        }
    }
    
    struct CountryName: Codable {
        let longName: TextField
        let etymology: TextField
        
        enum CodingKeys: String, CodingKey {
            case longName = "conventional long form"
            case etymology = "etymology"
        }
    }
    
    struct Capital: Codable {
        let name: TextField
        let etymology: TextField
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case etymology = "etymology"
        }
    }
    
    struct TextField: Codable {
        let text: String
        
        enum CodingKeys: String, CodingKey {
            case text = "text"
        }
    }
    
    
}
