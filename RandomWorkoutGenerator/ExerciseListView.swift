//
//  ExerciseListView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/24/23.
//

import SwiftUI

struct ExerciseListView: View {
    let exercises: [Exercise]
    let exerciseCount: Int
    let selectedMuscles: Set<String>
    
    var body: some View {
        VStack {
            Text("Exercises")
            List(Array(selectedMuscles), id: \.self) { muscle in
                Text(muscle.capitalized)
                    .fontWeight(.heavy)
                    .padding(.vertical)
                ForEach(exercises.filter { $0.target == muscle }, id: \.name) { exercise in
                    VStack {
                        Text(exercise.name.capitalized)
                    }
                }
            }
        }
    }
}


struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView(exercises: [
        Exercise(
            name: "Push-Up",
            target: "chest",
            gifUrl: "String",
            instructions: ["String"]
        ),
        Exercise(
            name: "Weighted standing curl",
            target: "biceps",
            gifUrl: "https://v2.exercisedb.io/image/tzLIV2Ep5peiAt",
            instructions: ["Stand with your feet shoulder-width apart and hold a dumbbell in each hand, palms facing forward.","Keep your elbows close to your torso and exhale as you curl the weights up to shoulder level.","Pause for a moment at the top, then inhale as you slowly lower the weights back down to the starting position.","Repeat for the desired number of repetitions."]
        )
        ], exerciseCount: 2, selectedMuscles: Set(["chest", "biceps"]))
    }
}
