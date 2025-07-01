//
//  FetchService.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import Foundation

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    private let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
    
    func fetchAPOD(_ date: String) async throws -> APOD {
        // Build fetch url
        let fetchDate = baseURL.appending(queryItems: [URLQueryItem(name: "date", value: date)])
        let fetchURL = fetchDate.appending(queryItems: [URLQueryItem(name: "api_key", value: Constants.apiKey)])
        print("fetchAPOD URL = \(fetchURL)")
        // Fetch data
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        // Handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        // Decode data
        let apod = try JSONDecoder().decode(APOD.self, from: data)
        print(apod)
        //Return apod
        return apod
    }
}
