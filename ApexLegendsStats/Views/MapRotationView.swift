//
//  MapRotationView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

struct MapRotationView: View {
    @StateObject private var controller = MapRotationController()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Apex Legends Map Rotation")
                    .font(.title)
                    .padding()
                
                if controller.isLoading {
                    ProgressView()
                } else {
                    mapRotationSection(title: "Battle Royale", rotation: controller.battleRoyale)
                    mapRotationSection(title: "Ranked", rotation: controller.ranked)
                    mapRotationSection(title: "Mixtape", rotation: controller.mixtape)
                }
                
                if let errorMessage = controller.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                Button("Refresh") {
                    controller.fetchMapRotation()
                }
                .padding()
            }
        }
        .onAppear {
            controller.fetchMapRotation()
        }
    }
    
    @ViewBuilder
    func mapRotationSection(title: String, rotation: MapRotation?) -> some View {
        if let rotation = rotation {
            VStack(alignment: .leading, spacing: 10) {
                Text(title).font(.headline)
                mapInfoView(info: rotation.current, label: "Current")
                mapInfoView(info: rotation.next, label: "Next")
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    func mapInfoView(info: MapInfo, label: String) -> some View {
        VStack(alignment: .leading) {
            Text("\(label): \(info.map)")
            if let eventName = info.eventName {
                Text("Event: \(eventName)")
            }
            if let remainingTime = info.remainingTimer {
                Text("Time Remaining: \(remainingTime)")
            }
            AsyncImage(url: URL(string: info.asset)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .frame(height: 100)
        }
    }
}
