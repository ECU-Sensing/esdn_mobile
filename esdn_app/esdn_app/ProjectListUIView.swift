//
//  ProjectListUIView.swift
//  esdn_app
//
//  Created by Colby Sawyer on 11/26/22.
//

import SwiftUI

struct ProjectListUIView: View {
    let countries = ["Air Quality", "Zentra Boxes"]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(countries, id: \.self) { country in
                    NavigationLink(destination: Text(country)) {
                        Image(systemName: "project")
                        Text(country)
                    }.padding()
                }
                .navigationTitle("Destinations")
            }
        }
    }
}

struct ProjectListUIView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectListUIView()
    }
}
