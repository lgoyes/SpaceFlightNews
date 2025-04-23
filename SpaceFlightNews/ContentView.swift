//
//  ContentView.swift
//  SpaceFlightNews
//
//  Created by Luis David Goyes Garces on 22/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ArticleListFactory.create()
    }
}

#Preview {
    ContentView()
}
