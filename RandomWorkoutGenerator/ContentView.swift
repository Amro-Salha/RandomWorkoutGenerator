//
//  ContentView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/22/23.
//

import SwiftUI


struct ContentView: View {
    
    let muscles = ["Chest", "Triceps", "Back", "Biceps", "Shoulders", "Quads", "Hamstrings", "Glutes", "Calves"]
    @State private var selectedMuscles = Set<String>()
    
    var body: some View {
        VStack {
            List(muscles, id: \.self, selection: $selectedMuscles) { muscle in HStack {
                    Text(muscle)
                    Spacer()
                    if selectedMuscles.contains(muscle) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    if selectedMuscles.contains(muscle) {
                        selectedMuscles.remove(muscle)
                    } else {
                        selectedMuscles.insert(muscle)
                    }
                }
            }
            .listStyle(InsetListStyle())
            
            Button(action: {
                print(selectedMuscles)
            }) {
                Text("Next")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            }

        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
