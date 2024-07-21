//
//  ApexAPIService.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation

class ApexAPIService {
    private let apiKey = "58677c0c1d7598df9e4859360bad184f"
    private let baseURL = "https://api.mozambiquehe.re"
    
    func fetchMapRotation() async throws -> MapRotationResponse {
        let urlString = "\(baseURL)/maprotation?auth=\(apiKey)&version=2"
        return try await performRequest(with: urlString, decodingType: MapRotationResponse.self)
    }
    
    
    func fetchPlayerStats(playerName: String, platform: String) async throws -> PlayerStats {
        let urlString = "\(baseURL)/bridge?auth=\(apiKey)&player=\(playerName)&platform=\(platform)"
        print("Fetching player stats from URL: \(urlString)")
        let result = try await performRequest(with: urlString, decodingType: PlayerStats.self)
        print("Received player stats: \(result)")
        return result
    }

    private func performRequest<T: Decodable>(with urlString: String, decodingType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: nil)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        print("Received data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
    }
}
