//
//  ApexLegendsStatsApp.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/19/24.
//

import SwiftUI

@main
struct ApexLegendsStatsApp: App {
    @State private var isActive = false
    
    var body: some Scene {
        WindowGroup {
            if isActive {
                ContentView()
            } else {
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
