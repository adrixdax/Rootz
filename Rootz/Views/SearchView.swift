//
//  SearchView.swift
//  Rootz
//
//  Created by Adriano d'Alessandro on 01/03/24.
//

import Foundation
import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    var searchAction: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search", text: $searchText, onCommit: searchAction)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .cornerRadius(4)
            Button(action: searchAction) {
                Image(systemName: "magnifyingglass")
            }
        }
    }
}
