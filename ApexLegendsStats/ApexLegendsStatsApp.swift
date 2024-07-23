//
//  ApexLegendsStatsApp.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

@main
struct ApexLegendsStatsApp: App {
    // Controls whether to show the launch screen or main content
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
            } else {
                // Display launch screen and transition to main content after a delay
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                self.isActive = true
                            }
                        }
                    }
            }
        }
    }
}

/// Displays the launch screen image
struct LaunchScreenView: View {
    var body: some View {
        GeometryReader { geometry in
            Image("LaunchScreenImage")
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
