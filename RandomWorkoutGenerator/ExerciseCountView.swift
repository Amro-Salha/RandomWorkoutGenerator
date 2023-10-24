//
//  ExerciseCountView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/23/23.
//

import SwiftUI

struct ExerciseCountView: View {
    @State private var selectedExerciseCount: Int = 3
    @State private var exercises: [[Exercise]] = []
    let apiKey = getApiKey(named: "RapidApiKey")
    let exerciseCount: [Int] = Array(1...10)
    
    var selectedMuscles: Set<String>

    var body: some View {
        VStack {
            Text("How many exercises would you like per muscle?")
                .padding(.bottom, 20)

            Picker(selection: $selectedExerciseCount, label: Text("Exercise Count")) {
                ForEach(exerciseCount, id: \.self) { count in
                    if count == 3 {
                        Text("\(count) (recommended)")
                            .tag(count)
                    } else {
                        Text("\(count)")
                            .tag(count)
                    }
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(height: 150)

            NavigationLink(destination: WorkoutFetchView(exerciseCount: selectedExerciseCount, selectedMuscles: selectedMuscles)){
                Text("Create Workout")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            Spacer()
        }
        .padding()
    }
    

    
}

struct ExerciseCountView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCountView(selectedMuscles: Set(["chest"]))
    }
}

