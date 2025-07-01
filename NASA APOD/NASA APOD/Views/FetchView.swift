//
//  FetchView.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import SwiftUI
import Combine
import UIKit

struct FetchView: View {
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
                            // MARK: Image/Media
                            ZStack(alignment: .bottom){
                                if vm.apod.media_type == "image"{
                                    AsyncImage(url: URL(string: vm.apod.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(minWidth: geo.size.width - 50, idealWidth: geo.size.width, maxWidth: geo.size.width, minHeight: 250.0, idealHeight: 400.0, maxHeight: 400.0, alignment: .center)
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: geo.size.width)
                                } else {
                                    VStack {
                                        if URL(string: vm.apod.url) != nil {
                                            MediaView(link: vm.apod.url)
                                                .frame(width: geo.size.width, height: 300)
                                                .padding(.bottom, 20)
                                        } else {
                                            Text("Invalid URL")
                                                .foregroundColor(.red)
                                                .padding()
                                        }
                                    }
                                }
                            }
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
    //FetchView(date: "2021-10-11")
    FetchView(date: "2025-06-30")
}
