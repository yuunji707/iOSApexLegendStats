//
//  MapRotationView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI
import RxSwift
import RxCocoa

/// A view that displays the current map rotation for Apex Legends
struct MapRotationView: View {
    @StateObject private var controller = MapRotationController()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    if controller.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    } else {
                        // Display map rotation for each game mode
                        mapRotationSection(title: "Battle Royale", rotation: controller.battleRoyale)
                        mapRotationSection(title: "Ranked", rotation: controller.ranked)
                        mapRotationSection(title: "Mixtape", rotation: controller.mixtape)
                    }
                    
                    if let errorMessage = controller.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Map Rotation")
        }
        .onAppear {
            controller.fetchMapRotation()
        }
    }
    
    /// Creates a section for a specific map rotation
    @ViewBuilder
    func mapRotationSection(title: String, rotation: MapRotation?) -> some View {
        if let rotation = rotation {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                mapInfoView(info: rotation.current, label: "Current Map")
                mapInfoView(info: rotation.next, label: "Next Map")
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    /// Displays information for a specific map
    @ViewBuilder
    func mapInfoView(info: MapInfo, label: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let remainingTime = info.remainingTimer {
                    HStack(spacing: 4) {
                        Text("Time remaining:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(remainingTime)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Text(info.map)
                .font(.body)
                .fontWeight(.semibold)
            
            if let eventName = info.eventName {
                Text(eventName)
                    .font(.caption)
                    .foregroundColor(.orange)
            }
            
            // Asynchronously load and display the map image
            AsyncImage(url: URL(string: info.asset)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
            .cornerRadius(8)
            .clipped()
        }
    }
}
