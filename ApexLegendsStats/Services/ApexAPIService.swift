//
//  ApexAPIService.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation
import RxSwift

class ApexAPIService {
    private let apiKey = "58677c0c1d7598df9e4859360bad184f"
    private let baseURL = "https://api.mozambiquehe.re"
    
    func fetchMapRotation() -> Observable<MapRotationResponse> {
        let urlString = "\(baseURL)/maprotation?auth=\(apiKey)&version=2"
        return performRequest(with: urlString)
    }
    
    func fetchPlayerStats(playerName: String, platform: String) async throws -> PlayerStats {
        let urlString = "\(baseURL)/bridge?auth=\(apiKey)&player=\(playerName)&platform=\(platform)"
        print("Fetching player stats from URL: \(urlString)")
        let result = try await performRequestAsync(with: urlString, decodingType: PlayerStats.self)
        print("Received player stats: \(result)")
        return result
    }
    
    func fetchNews() async throws -> [NewsItem] {
        let urlString = "\(baseURL)/news?auth=\(apiKey)"
        let (data, _) = try await URLSession.shared.data(from: URL(string: urlString)!)
        let decoder = JSONDecoder()
        return try decoder.decode([NewsItem].self, from: data)
    }
    
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
    
    private func performRequestAsync<T: Decodable>(with urlString: String, decodingType: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResult = try JSONDecoder().decode(T.self, from: data)
        return decodedResult
    }
}
