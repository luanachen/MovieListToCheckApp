//
//  AddMovieView.swift
//  MoviesToCheckApp
//
//  Created by Luana Chen Chih Jun on 16/09/20.
//  Copyright © 2020 Chen. All rights reserved.
//

import SwiftUI

struct AddMovieView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name: String = ""
    @State private var isLoading: Bool = false
    
    @ObservedObject var httpClient = HTTPMovieClient()
    
    private func saveMovie() {
        isLoading = true
        httpClient.saveMovie(name: self.name) { success in
            self.isLoading = false
            if success {
                self.presentationMode.wrappedValue.dismiss()
            } else {
                // show user the error message that save was not successful
            }
        }
    }
    
    var body: some View {
        LoadingView(isShowing: $isLoading) {
            NavigationView {
                
                VStack(alignment: .center, spacing: 20) {
                    Spacer()
                    
                    TextField("Enter name", text: self.$name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer()
                    
                    Button("Add Movie") {
                        self.saveMovie()
                    }
                    .padding(8)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(8)
                    
                    Spacer()
                    
                }.padding()
                    
                    .navigationBarTitle("Add Movie")
                    .navigationBarItems(trailing: Button("Close") {
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
        }
    }
}

struct AddMovieView_Previews: PreviewProvider {
    static var previews: some View {
        AddMovieView()
    }
}
