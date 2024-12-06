//
//  FilterRecipeView.swift
//  FetchTakeHome
//
//  Created by Danilo Silveira on 2024-12-05.
//

import SwiftUI

struct FilterRecipeView: View {
    @Environment(\.dismiss) var dismissal
    @ObservedObject var filterRecipeVM: RecipesViewModel
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                List {
                    Section("Selected Cusine") {
                        ForEach(filterRecipeVM.cusines, id: \.self) { cusine in
                            HStack {
                                Text(cusine)
                                Spacer()
                                if filterRecipeVM.selectedFilters.contains(cusine) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue) // Checkmark color
                                }
                            }.contentShape(Rectangle())
                                .onTapGesture {
                                    filterRecipeVM.toggleFilter(cusine)
                                }
                        }
                    }.listStyle(InsetGroupedListStyle())
                }
                HStack(alignment: .center) {
                    Button {
                        filterRecipeVM.selectAllFilters()
                    } label: {
                        Text("Select All").frame(maxWidth: .infinity)
                    }
                    Spacer()
                    Button {
                        filterRecipeVM.deselectAllFilters()
                    } label: {
                        Text("Remove All").frame(maxWidth: .infinity)
                    }
                }
                Spacer()
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismissal()
                }
            }
        }
        
    }
}

#Preview {
    FilterRecipeView(filterRecipeVM: RecipesViewModel())
}
