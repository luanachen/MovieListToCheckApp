//
//  ContentView.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @State private var isLoading: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var httpClient = HTTPMovieClient()
    
    let screenSize = UIScreen.main.bounds
    
    private func getAllMovies() {
        isLoading = true
        httpClient.getAllMovies() { success in
            self.isLoading = false
            if !success {
                // show error
            }
        }
    }
    
    var body: some View {
        
        LoadingView(isShowing: $isLoading) {
            
            NavigationView {
                
                List(self.httpClient.movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailsView(movie: movie)) {
                        VStack {
                            Text(movie.title)
                                .padding()
                                .font(.system(size: 25))
                        }
                    }
                }
                    
                .navigationBarTitle("Movies")
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = true
                }){
                    Image(systemName: "plus")
                })
                    .onAppear {
                        self.getAllMovies()
                }
                
            }
            .sheet(isPresented: self.$isPresented, onDismiss: {
                self.getAllMovies()
            }, content: {
                AddMovieView()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let httpClient = HTTPMovieClient()
        httpClient.movies = [Movie(title: "Lion King")]
        var contentView = ContentView()
        contentView.httpClient = httpClient
        return contentView
    }
}
