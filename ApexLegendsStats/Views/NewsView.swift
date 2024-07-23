//
//  NewsView.swift
//  ApexLegendsStats
//
//  Created by Younis on 7/22/24.
//

import SwiftUI

/// A view that displays a list of Apex Legends news items
struct NewsView: View {
    // MARK: - State Properties
    @State private var newsItems: [NewsItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    @State private var hasMorePages = true
    
    private let newsController = NewsController()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(newsItems) { item in
                    NewsItemView(item: item)
                }
                
                if hasMorePages {
                    Button("Load More") {
                        Task {
                            await loadMoreNews()
                        }
                    }
                    .disabled(isLoading)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Apex Legends News")
            .onAppear {
                Task {
                    await loadNews()
                }
            }
            .refreshable {
                await refreshNews()
            }
            .overlay(Group {
                if isLoading {
                    ProgressView()
                }
            })
            .alert(isPresented: Binding<Bool>(
                get: { self.errorMessage != nil },
                set: { if !$0 { self.errorMessage = nil } }
            )) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "An unknown error occurred"))
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Loads the initial set of news items
    @Sendable
    private func loadNews() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let items = try await newsController.fetchNews(page: currentPage)
            self.newsItems = items
            hasMorePages = items.count == 5  // Assuming 5 items per page
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// Loads the next page of news items
    @Sendable
    private func loadMoreNews() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        currentPage += 1
        
        do {
            let newItems = try await newsController.fetchNews(page: currentPage)
            self.newsItems.append(contentsOf: newItems)
            hasMorePages = newItems.count == 5  // Assuming 5 items per page
        } catch {
            self.errorMessage = error.localizedDescription
            currentPage -= 1  // Revert page increment on error
        }
        
        isLoading = false
    }
    
    /// Refreshes the news list from the beginning
    @Sendable
    private func refreshNews() async {
        currentPage = 1
        hasMorePages = true
        await loadNews()
    }
}

/// A view that displays a single news item
struct NewsItemView: View {
    let item: NewsItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: item.img)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
            } placeholder: {
                ProgressView()
            }
            
            Text(item.title)
                .font(.headline)
            
            Text(item.short_desc)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Link("Read More", destination: URL(string: item.link)!)
                .font(.caption)
        }
        .padding(.vertical)
    }
}
