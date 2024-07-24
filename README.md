# Apex Legends Stats

## Description

Apex Legends Stats is an iOS application that provides real-time information and statistics for the popular battle royale game, Apex Legends. Built using the Model-View-Controller (MVC) architectural pattern, this app leverages the [Apex Legends API](https://apexlegendsapi.com) to fetch up-to-date data. It offers features such as current map rotations, player statistics, latest news, and server status updates, all organized within a clear and maintainable MVC structure.

## Features

- **Map Rotation**: View current and upcoming maps for various game modes.
- **Player Statistics**: Look up detailed stats for any player across different platforms.
- **News Feed**: Stay updated with the latest Apex Legends news and announcements.
- **Server Status**: Check the current status of Apex Legends servers across different regions.

## Technologies and Architecture

- **Swift**: The primary programming language used for development.
- **SwiftUI**: Used for building the user interface with a declarative syntax.
- **RxSwift**: Utilized for handling asynchronous operations and reactive programming.
- **Cocoapods**: Used for dependency management.
- **Apex Legends API**: The data source for all Apex Legends related information.
- **Model-View-Controller (MVC)**: The architectural pattern used to structure the app.
- **XCTest**: Used for unit testing and UI testing to ensure code quality and reliability.

## Architecture

This app follows the Model-View-Controller (MVC) architectural pattern:

- **Model**: Represents the data and business logic. Located in files like `MapRotationModel.swift`, `PlayerStatsModel.swift`, etc.
- **View**: Handles the presentation layer. Implemented using SwiftUI in files like `MapRotationView.swift`, `PlayerStatsView.swift`, etc.
- **Controller**: Manages the communication between Model and View. Found in files like `MapRotationController.swift`, `PlayerStatsController.swift`, etc.

This separation of concerns allows for better organization, maintainability, and testability of the codebase.

## Setup

1. **Prerequisites**:
   - Xcode 13.0 or later
   - iOS 15.0 or later
   - CocoaPods

2. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/apex-legends-stats.git
   cd apex-legends-stats
   ```

3. **Install Dependencies**:
   ```bash
   pod install
   ```

4. **Open the Project**:
   Open `ApexLegendsStats.xcworkspace` in Xcode.

5. **Configure API Key**:
   Obtain an API key from [Apex Legends API](https://apexlegendsapi.com) and add it to the `ApexAPIService.swift` file:
   ```swift
   private let apiKey = "YOUR_API_KEY_HERE"
   ```

6. **Build and Run**:
   Select your target device or simulator and click the "Run" button in Xcode.

## API Usage

This app relies on the Apex Legends API (apexlegendsapi.com) for all its data. Please ensure you comply with their terms of service and usage limits. You may need to sign up for an account and obtain an API key to use their services.
