//
//  ApexAPIService.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

//
//  ApexAPIService.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation
import RxSwift

/// A service class for interacting with the Apex Legends API
class ApexAPIService {
    // API credentials and base URL
    private let apiKey = "58677c0c1d7598df9e4859360bad184f"
    private let baseURL = "https://api.mozambiquehe.re"
    
    /// Fetches the current map rotation
    /// - Returns: An Observable of MapRotationResponse
    func fetchMapRotation() -> Observable<MapRotationResponse> {
        let urlString = "\(baseURL)/maprotation?auth=\(apiKey)&version=2"
        return performRequest(with: urlString)
    }
    
    /// Fetches player statistics asynchronously
    /// - Parameters:
    ///   - playerName: The name of the player
    ///   - platform: The platform the player is on
    /// - Returns: A PlayerStats object
    /// - Throws: An error if the request fails
    func fetchPlayerStats(playerName: String, platform: String) async throws -> PlayerStats {
        let urlString = "\(baseURL)/bridge?auth=\(apiKey)&player=\(playerName)&platform=\(platform)"
        print("Fetching player stats from URL: \(urlString)")
        let result = try await performRequestAsync(with: urlString, decodingType: PlayerStats.self)
        print("Received player stats: \(result)")
        return result
    }
    
    /// Fetches news items asynchronously
    /// - Returns: An array of NewsItem objects
    /// - Throws: An error if the request fails
    func fetchNews() async throws -> [NewsItem] {
        let urlString = "\(baseURL)/news?auth=\(apiKey)"
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        let decoder = JSONDecoder()
        return try decoder.decode([NewsItem].self, from: data)
    }
    
    /// Fetches server status asynchronously
    /// - Returns: A ServerStatus object
    /// - Throws: An error if the request fails
    func fetchServerStatus() async throws -> ServerStatus {
        let urlString = "\(baseURL)/servers?auth=\(apiKey)"
        return try await performRequestAsync(with: urlString, decodingType: ServerStatus.self)
    }
    
    /// Performs a network request and returns an Observable
    /// - Parameter urlString: The URL string for the request
    /// - Returns: An Observable of the decoded response
    private func performRequest<T: Decodable>(with urlString: String) -> Observable<T> {
        guard let url = URL(string: urlString) else {
            return Observable.error(NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        }
        
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let data = data else {
                    observer.onError(NSError(domain: "No Data", code: 0, userInfo: nil))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext(decodedData)
                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    /// Performs an asynchronous network request
    /// - Parameters:
    ///   - urlString: The URL string for the request
    ///   - decodingType: The type to decode the response into
    /// - Returns: The decoded response of type T
    /// - Throws: An error if the request or decoding fails
    private func performRequestAsync<T: Decodable>(with urlString: String, decodingType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResult = try JSONDecoder().decode(T.self, from: data)
        return decodedResult
    }
}
