//
//  FetchImageMediaView.swift
//  NASA APOD
//
//  Created by Adam Gerber on 01/07/2025.
//

import SwiftUI

struct FetchImageMediaView: View {
    @StateObject var vm = ViewModel()
    let date: String
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
                            // MARK: Image
                            ZStack(alignment: .bottom){
                                if vm.apod.media_type == "image"{
                                    AsyncImage(url: URL(string: vm.apod.url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(minWidth: geo.size.width, idealWidth: geo.size.width, maxWidth: geo.size.width, minHeight: 250.0, idealHeight: 400.0, maxHeight: 450.0, alignment: .center)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: geo.size.width)
                                } else {
                                    // MARK: Media
                                    VStack {
                                        if URL(string: vm.apod.url) != nil {
                                            MediaView(link: vm.apod.url)
                                                .frame(width: geo.size.width, height: 300)
                                        
                                        } else {
                                            Text("Invalid URL")
                                                .foregroundColor(.red)
                                                .padding()
                                        }
                                    }
                                }
                            }
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
    //FetchImageMediaView(date: "2021-10-11")
    FetchImageMediaView(date: "2025-06-30")
}
