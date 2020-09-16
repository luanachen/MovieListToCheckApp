//
//  MovieDetailsView.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import SwiftUI

struct MovieDetailsView: View {
    
    let movie: Movie
    
    @State private var reviewTitle: String = ""
    @State private var reviewBody: String = ""
    @State private var isLoading: Bool = false
    
    @ObservedObject private var httpClient = HTTPMovieClient()
    
    @Environment(\.presentationMode) private var presentationMode
    
    private func deleteMovie() {
        isLoading = true
        httpClient.deleteMovie(movie: movie) { success in
            
            if success {
                DispatchQueue.main.async {
                    self.presentationMode.wrappedValue.dismiss()
                }
            } else {
                // show error
                print("error deleting")
            }
        }
    }
    
    private func getReviewsByMovie() {
        isLoading = true
        self.httpClient.getReviewsByMovie(movie: self.movie) { success in
            self.isLoading = false
            if !success {
                // show error
            }
        }
    }
    
    private func saveReview() {
        let review = Review(title: self.reviewTitle, body: self.reviewBody, movie: movie)
        isLoading = true
        self.httpClient.saveReview(review: review) { success in
            self.isLoading = false
            if success {
                self.getReviewsByMovie()
            } else {
                // show error
            }
        }
    }
    
    var body: some View {
        
        LoadingView(isShowing: $isLoading) {
            Form {
                
                Section(header: Text("ADD A REVIEW").fontWeight(.bold)) {
                    VStack(alignment: .center, spacing: 10) {
                        TextField("Enter Title",text: self.$reviewTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        TextField("Enter Body",text: self.$reviewBody) .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button("Save") {
                            self.saveReview()
                        }
                        .padding(10)
                        .foregroundColor(Color.blue)
                        .cornerRadius(6.0)
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                
                Section(header: Text("REVIEWS").fontWeight(.bold)) {
                    
                    ForEach(self.httpClient.reviews ?? [Review](), id: \.id) { review in
                        VStack(spacing: 8) {
                            Text(review.title)
                                .fontWeight(.semibold)
                            Text(review.body)
                        }
                    }
                }
            }
                
            .onAppear(perform: {
                self.getReviewsByMovie()
            })
                
                .navigationBarTitle(self.movie.title)
                .navigationBarItems(trailing: Button(action: {
                    self.deleteMovie()
                }) {
                    Image(systemName: "trash.fill")
                })
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie(title: "Birds of Prey"))
    }
}
