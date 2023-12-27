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
        "Calves": "calves"
    ]
    
    @State private var selectedMuscles = Set<String>()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Which muscles do you want to work out today?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.12156862745098039))
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                        .frame(width: 250.0)
                    
          
                    List(Array(muscles.keys).sorted(), id: \.self, selection: $selectedMuscles) { muscle in HStack {
                        Text(muscle)
                            .foregroundColor(Color.white)
                            .padding(.vertical)
                        
                        Spacer()
                        
                            if selectedMuscles.contains(muscles[muscle]!) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color(red: 0.12941176470588237, green: 0.7607843137254902, blue: 0.4627450980392157))
                            }
                        }
                        .listRowBackground(Color(red: 0.07450980392156863, green: 0.13333333333333333, blue: 0.2))
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedMuscles.contains(muscles[muscle]!) {
                                selectedMuscles.remove(muscles[muscle]!)
                            } else {
                                selectedMuscles.insert(muscles[muscle]!)
                            }
                        }

                    }
                    .listStyle(InsetListStyle())
                    .cornerRadius(20)
                    .padding(.all)
                    .background(Color(red: 0.051, green: 0.10196078431372549, blue: 0.1607843137254902).edgesIgnoringSafeArea(.all))
                    
                    
                    NavigationLink(destination: ExerciseListView(selectedMuscles: selectedMuscles)) {
                        Text("NEXT")
                            .fontWeight(.bold)
                    }
                    .padding()
                    .background(Color(red: 0.165, green: 0.2196078431372549, blue: 0.2784313725490196))
                    .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.12156862745098039))
                    .cornerRadius(8)
                }
                
            }
            .background(Color(red: 0.050980392156862744, green: 0.10196078431372549, blue: 0.1607843137254902))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
