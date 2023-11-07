//
//  ContentView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/22/23.
//

import SwiftUI

struct Exercise: Codable, Equatable {
    let id: String
    let name: String
    let target: String
    let gifUrl: String
    let instructions: [String]
}


struct ContentView: View {
    
    let muscles: [String: String] = [
        "Chest": "pectorals",
        "Triceps": "triceps",
        "Back": "lats",
        "Biceps": "biceps",
        "Shoulders": "delts",
        "Quads": "quads",
        "Hamstrings": "hamstrings",
        "Glutes": "glutes",
        "Calves": "calves"]
    
    @State private var selectedMuscles = Set<String>()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Which muscles do you want to work out today?")
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    .frame(width: 250.0)
                List(Array(muscles.keys), id: \.self, selection: $selectedMuscles) { muscle in HStack {
                        Text(muscle)
                        Spacer()
                        if selectedMuscles.contains(muscles[muscle]!) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if selectedMuscles.contains(muscles[muscle]!) {
                            selectedMuscles.remove(muscles[muscle]!)
                            print(selectedMuscles)
                        } else {
                            selectedMuscles.insert(muscles[muscle]!)
                            print(selectedMuscles)
                        }
                    }
                }
                .listStyle(InsetListStyle())
                
                NavigationLink(destination: ExerciseListView(selectedMuscles: selectedMuscles)) {
                    Text("Next")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }

        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
