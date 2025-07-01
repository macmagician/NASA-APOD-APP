//
//  FetchTextView.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import SwiftUI
import Combine
import UIKit

struct FetchTextView: View {
    @StateObject var vm = ViewModel()
    let date: String
    @StateObject private var orientationManager = OrientationManager.shared
    var body: some View {
        GeometryReader { geo in
            ZStack{
                VStack{
                    switch vm.status {
                    case .notStarted:
                        Text("Empty")
                        EmptyView()
                        
                    case .fetching:
                        Text("Fetching")
                        ProgressView()
                        
                    case .successAPOD:
                        ScrollView {
                            // MARK: Title
                            Text("\(String(vm.apod.title!))")
                                .font(.title3)
                                .padding(.top, 20)
                            Text("Date: \(String(vm.apod.date))")
                            
                            // MARK: Explanation
                            Text("\(vm.apod.explanation)")
                                .font(.body)
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .padding(.leading, orientationManager.orientation.isLandscape ? 60 : 0)
                                .padding(.trailing, orientationManager.orientation.isLandscape ? 60 : 0)
                            Spacer(minLength: 100)
                        }
                        
                    case .failed(let error):
                        Text("Error")
                        Text(error.localizedDescription)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear {
                Task{
                    await vm.getApodDateData(for: date)
                }
            }
            .onChange(of: date) { newDate in
                Task {
                    await vm.getApodDateData(for: newDate)
                }
            }
        }
        .ignoresSafeArea()
    }
}


#Preview {
    FetchTextView(date: "2025-06-30")
}
