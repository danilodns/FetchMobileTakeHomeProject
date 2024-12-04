//
//  FetchTakeHomeApp.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-03.
//

import SwiftUI

@main
struct FetchTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: RecipesViewModel())
        }
    }
}
