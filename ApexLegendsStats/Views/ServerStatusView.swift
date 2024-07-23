//
//  ServerStatusView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import SwiftUI

/// A view that displays the status of Apex Legends servers
struct ServerStatusView: View {
    @StateObject private var controller = ServerStatusController()
    @State private var isRefreshing = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    serverTypePicker
                    
                    statusGrid
                    
                    dataSourceLink
                }
                .padding()
            }
            .navigationTitle("Server Status")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refreshData) {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(isRefreshing ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                    }
                }
            }
        }
        .onAppear {
            controller.fetchServerStatus()
        }
    }
    
    /// Picker for selecting the server type
    private var serverTypePicker: some View {
        Picker("Server Type", selection: $controller.selectedServerType) {
            Text("Origin").tag(ServerType.origin)
            Text("EA Nova").tag(ServerType.eaNova)
            Text("EA Accounts").tag(ServerType.eaAccounts)
            Text("Crossplay").tag(ServerType.crossplay)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.vertical, 8)
        .onChange(of: controller.selectedServerType) { _ in
            controller.updateCurrentRegionStatus()
        }
    }
    
    /// Grid displaying status cards for each region
    private var statusGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(controller.currentRegionStatus) { region in
                StatusCard(region: region)
            }
        }
    }
    
    /// Link to the data source website
    private var dataSourceLink: some View {
        Link(destination: URL(string: "https://apexlegendsstatus.com")!) {
            Text("Data from Apex Legends Status")
                .font(.footnote)
                .foregroundColor(.blue)
        }
    }
    
    /// Refreshes the server status data
    private func refreshData() {
        isRefreshing = true
        controller.fetchServerStatus()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isRefreshing = false
        }
    }
}

/// A view that displays the status of a single server region
struct StatusCard: View {
    let region: RegionStatusData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(region.name)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                statusIndicator
                Spacer()
                Text("\(region.responseTime) ms")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
    
    /// Visual indicator of the server status (UP or DOWN)
    private var statusIndicator: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(region.status == "UP" ? Color.green : Color.red)
                .frame(width: 10, height: 10)
            Text(region.status)
                .font(.subheadline)
                .foregroundColor(region.status == "UP" ? .green : .red)
        }
    }
}
