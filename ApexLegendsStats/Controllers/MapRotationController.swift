//
//  MapRotationController.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import Foundation
import RxSwift
import RxCocoa

class MapRotationController: ObservableObject {
    @Published var battleRoyale: MapRotation?
    @Published var ranked: MapRotation?
    @Published var mixtape: MapRotation?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private let apiService = ApexAPIService()
    private let disposeBag = DisposeBag()
    private var timer: Disposable?
    
    init() {
        setupTimer()
    }
    
    func fetchMapRotation() {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchMapRotation()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response in
                self?.battleRoyale = response.battleRoyale
                self?.ranked = response.ranked
                self?.mixtape = response.ltm
                self?.setupTimer()
                self?.isLoading = false
            }, onError: { [weak self] error in
                self?.errorMessage = "Error: \(error.localizedDescription)"
                self?.isLoading = false
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTimer() {
        timer?.dispose()
        
        guard [battleRoyale, ranked, mixtape]
            .compactMap({ $0?.current.remainingSecs })
            .min() != nil else { return }
        
        timer = Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.updateTimers()
            })
        
        timer?.disposed(by: disposeBag)
    }
    
    private func updateTimers() {
        let rotations = [battleRoyale, ranked, mixtape]
        
        for (index, rotation) in rotations.enumerated() {
            guard var updatedRotation = rotation else { continue }
            
            if var remainingSecs = updatedRotation.current.remainingSecs {
                remainingSecs -= 1
                
                if remainingSecs <= 0 {
                    fetchMapRotation()
                    return
                }
                
                let hours = remainingSecs / 3600
                let minutes = (remainingSecs % 3600) / 60
                let seconds = remainingSecs % 60
                
                // Create a new MapInfo instance with the updated remainingTimer and remainingSecs
                var updatedMapInfo = updatedRotation.current
                
                if hours > 0 {
                    updatedMapInfo.remainingTimer = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
                } else {
                    updatedMapInfo.remainingTimer = String(format: "%02d:%02d", minutes, seconds)
                }
                
                updatedMapInfo.remainingSecs = remainingSecs
                
                // Update the rotation with the new MapInfo
                updatedRotation.current = updatedMapInfo
                
                switch index {
                case 0: battleRoyale = updatedRotation
                case 1: ranked = updatedRotation
                case 2: mixtape = updatedRotation
                default: break
                }
            }
        }
    }
}
