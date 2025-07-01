//
//  ContentView.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDate = Date.now
    @StateObject private var networkMonitor = NetworkMonitor()
    
    private var selectedDateString: String {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: selectedDate)
        let yearString = String(dateComponents.year!)
        let monthString = String(format: "%02d", dateComponents.month!)
        let dayString = String(format: "%02d", dateComponents.day!)
        return "\(yearString)-\(monthString)-\(dayString)"
        //return "2021-10-11"
    }
    
    var body: some View {
        TabView {
            NavigationStack {
                VStack(alignment: .center){
                    // Display date message
                    Text("Select a NASA APOD date:")
                    // Check network connectivity in case calendar should be disabled
                    if !networkMonitor.isConnected {
                        Text("No network connection. Calendar is disabled.")
                            .foregroundColor(.red)
                    }
                    HStack{
                        Spacer()
                        // Display calendar date picker
                        DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: .date) {
                        }
                        .labelsHidden()
                        .disabled(!networkMonitor.isConnected)
                        
                        Spacer()
                    }
                    VStack{
                        // Display Fetchview (image/media and text) with fetched data for date
                        FetchView(date: selectedDateString)
                    }
                }
            }
            .tabItem { Label("Media & Text", systemImage: "text.below.photo") }
            NavigationStack {
                VStack{
                    Spacer()
                    // Display FetchTextview (text only) with fetched data for date
                    FetchTextView(date: selectedDateString)
                }
            }
            .tabItem { Label("Text Only", systemImage: "text.page") }
            NavigationStack {
                VStack{
                    Spacer()
                    // Display FetchImageMediaView (Image/Media only) with fetched data for date
                    FetchImageMediaView(date: selectedDateString)
                }
            }
            .tabItem { Label("Image/Media Only", systemImage: "photo") }
        }
    }
}

#Preview {
    ContentView()
}
