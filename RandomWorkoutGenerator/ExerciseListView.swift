//
//  ExerciseListView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/24/23.
//

import SwiftUI

struct ExerciseListView: View {
    @State private var exercises: [String: [Exercise]] = UserDefaults.standard.fetchAllExercises() ?? [:]
    @State private var muscleExercises: [Exercise] = []
    let selectedMuscles: Set<String>
    
    let apiKey = getApiKey(named: "RapidApiKey")
    let dispatchGroup = DispatchGroup()
    
    var body: some View {
        VStack{
            Text("Exercises")
                .font(.largeTitle)
                .fontWeight(.bold)
            ScrollView{
                ForEach(Array(selectedMuscles).sorted(), id: \.self) { muscle in
                    Text(muscle.capitalized)
                        .fontWeight(.heavy)
                        .padding(.vertical)
                    let muscleExercises = exercises[muscle] ?? []
                    ForEach(muscleExercises, id: \.id) { exercise in
                        HStack {
                            NavigationLink(destination: ExerciseDetailsView(exercise: exercise)){
                                Text(exercise.name)
                                    .foregroundColor(Color.black)
                                    .padding(.vertical)
                            }
                                Spacer()
                                Button( action : {
                                    UserDefaults.standard.deleteExercise(exercise.id, forMuscle: muscle)
                                    if var muscleExercises = exercises[muscle],
                                       let index = muscleExercises.firstIndex(where: {$0.id == exercise.id}) {
                                        muscleExercises.remove(at: index)
                                        exercises[muscle] = muscleExercises
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .foregroundColor(.red)
                                }
                        }
                        .padding(.horizontal, 20.0)
                    }
                    Button( action : {
                        dispatchGroup.enter()
                        fetchExercises(for: muscle) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let newExercise):
                                    UserDefaults.standard.addExerciseForMuscle(newExercise, forMuscle: muscle)
                                case .failure(let error):
                                    print("Error fetching exercises for \(muscle): \(error)")
                                }
                                dispatchGroup.leave()
                            }
                        }
                    }) {
                        Image(systemName: "plus")
                        Text("Add new exercise")
                    }
                }
            }
            .onAppear {
                self.exercises = UserDefaults.standard.fetchAllExercises() ?? [:]
            }
        }
    }
    
    func fetchExercises(for muscle: String, completion: @escaping (Result<Exercise, Error>) -> Void) {
        
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
                    let fetchedExercises = try JSONDecoder().decode([Exercise].self, from: data).shuffled()
                    // Find the first exercise that's not already in the list
                    if let uniqueExercise = fetchedExercises.first(where: { !self.muscleExercises.contains($0) }) {
                        DispatchQueue.main.async {
                            completion(.success(uniqueExercise))
                            if var muscleExercises = self.exercises[muscle] {
                                muscleExercises.append(uniqueExercise)
                                self.exercises[muscle] = muscleExercises
                            } else {
                                self.exercises[muscle] = [uniqueExercise]
                            }
                        }
                    } else {
                        // If there are no unique exercises, return an error or handle it as needed
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "", code: 204, userInfo: nil))) // No Content error
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
        
    }
}


struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExerciseListView(selectedMuscles: Set(["pectorals", "biceps"])
            )
        }
    }
}

func getApiKey(named keyName: String) -> String? {
    guard let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist"),
          let plist = NSDictionary(contentsOfFile: filePath) else {
        return nil
    }
    return plist[keyName] as? String
}
