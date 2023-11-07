//
//  UserDefaultsManager.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 11/2/23.
//

import Foundation

extension UserDefaults {
    
    func addExerciseForMuscle(_ exercise: Exercise, forMuscle muscle: String) {
        var exercisesForMuscle = fetchSavedExercisesForMuscle(forMuscle: muscle) ?? []
        
        exercisesForMuscle.append(exercise)
        
        saveExercisesForMuscle(exercisesForMuscle, forMuscle: muscle)
    }
    
    func saveExercisesForMuscle(_ exercises: [Exercise], forMuscle muscle: String) {
        var exercisesDictionary = fetchAllExercises() ?? [:]
        exercisesDictionary[muscle] = exercises
        if let encoded = try? JSONEncoder().encode(exercisesDictionary) {
            set(encoded, forKey: UserDefaultsKeys.exercises.rawValue)
        }
    }
    
    func fetchSavedExercisesForMuscle(forMuscle muscle: String) -> [Exercise]? {
        guard let exerciseDictionary = fetchAllExercises() else { return nil }
        return exerciseDictionary[muscle]
    }
    
    func fetchAllExercises() -> [String: [Exercise]]? {
        if let data = data(forKey: UserDefaultsKeys.exercises.rawValue) {
            return try? JSONDecoder().decode([String: [Exercise]].self, from: data)
        }
        return nil
    }
    
    func deleteExercises(forMuscle muscle: String) {
        var exerciseDictionary = fetchAllExercises() ?? [:]
        exerciseDictionary[muscle] = nil
        if let encoded = try? JSONEncoder().encode(exerciseDictionary) {
            set(encoded, forKey: UserDefaultsKeys.exercises.rawValue)
        }
    }
    
    func deleteExercise(_ exerciseId: String, forMuscle muscle: String) {
        var exercisesDictionary = fetchAllExercises() ?? [:]
        
        guard var exercisesForMuscle = exercisesDictionary[muscle] else {return}
        
        exercisesForMuscle.removeAll{ $0.id == exerciseId}
        exercisesDictionary[muscle] = exercisesForMuscle
        
        if let encoded = try? JSONEncoder().encode(exercisesDictionary) {
            set(encoded, forKey: UserDefaultsKeys.exercises.rawValue)
        }
    }
    
    private enum UserDefaultsKeys: String {
        case exercises
    }
}
