//
//  WorkoutFetchView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/24/23.
//

import SwiftUI

struct Exercise: Decodable {
    let name: String
    let target: String
    let gifUrl: String
    let instructions: [String]
}

struct WorkoutFetchView: View {
    @State private var isLoading: Bool = false
    @State private var exercises: [Exercise] = []
    
    let apiKey = getApiKey(named: "RapidApiKey")
    
    var exerciseCount: Int
    var selectedMuscles: Set<String>
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                ExerciseListView(exercises: exercises, exerciseCount: exerciseCount, selectedMuscles: selectedMuscles)
            }
        }.onAppear {
            if exercises.count != exerciseCount * selectedMuscles.count {
                isLoading = true
                let dispatchGroup = DispatchGroup()
                
                for muscle in selectedMuscles {
                    dispatchGroup.enter()
                    fetchExercises(for: muscle) { result in
                        switch result {
                        case .success(let fetchedExercises):
                            exercises.append(contentsOf: fetchedExercises)
                        case .failure(let error):
                            print("Error fetching exercises for \(muscle): \(error)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    isLoading = false
                }
            }
        }
    }
    
    func fetchExercises(for muscle: String, completion: @escaping (Result<[Exercise], Error>) -> Void) {
        
        let urlString = "https://exercisedb.p.rapidapi.com/exercises/target/\(muscle)?limit=200"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: 404, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey!, forHTTPHeaderField: "X-RapidAPI-Key")
        request.addValue("exercisedb.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8) ?? "Failed to convert data to string")
            if let data = data {
                do {
                    let exercises = try JSONDecoder().decode([Exercise].self,from: data)
                    let shuffledExercises = exercises.shuffled()
                    let selectedExercises = Array(shuffledExercises.prefix(exerciseCount))
                    completion(.success(selectedExercises))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
        
    }
}

struct WorkoutFetchView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutFetchView(exerciseCount: 3, selectedMuscles: Set(["chest"]))
    }
}

func getApiKey(named keyName: String) -> String? {
    guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath) else {
        return nil
    }
    return plist[keyName] as? String
}
