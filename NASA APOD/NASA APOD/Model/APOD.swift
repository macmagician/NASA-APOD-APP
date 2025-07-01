//
//  APOD.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import Foundation

// APOD is Codable for cache serialization
struct APOD : Codable {
    let copyright : String?
    let date : String
    let explanation : String
    let hdurl : String?
    let media_type : String?
    let service_version : String?
    let title : String?
    let url : String
    
    enum CodingKeys: String, CodingKey {
        
        case copyright = "copyright"
        case date = "date"
        case explanation = "explanation"
        case hdurl = "hdurl"
        case media_type = "media_type"
        case service_version = "service_version"
        case title = "title"
        case url = "url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        date = try container.decode(String.self, forKey: .date)
        explanation = try container.decode(String.self, forKey: .explanation)
        hdurl = try container.decodeIfPresent(String.self, forKey: .hdurl)
        media_type = try container.decodeIfPresent(String.self, forKey: .media_type)
        service_version = try container.decodeIfPresent(String.self, forKey: .service_version)
        title = try container.decodeIfPresent(String.self, forKey: .title)
        url = try container.decode(String.self, forKey: .url)
    }
    
}
