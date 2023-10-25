//
//  ExerciseDetailsView.swift
//  RandomWorkoutGenerator
//
//  Created by Amro Salha on 10/24/23.
//

import SwiftUI
import UIKit

struct ExerciseDetailsView: View {
    @State private var isLoading: Bool = true
    
    let exercise: Exercise
    
    var body: some View {
        VStack {
            Text(exercise.name)
            Spacer()
            AnimatedImage(gifURL: URL(string: exercise.gifUrl)!, isLoading: $isLoading)
                .overlay(
                    Group {
                        if isLoading {
                            ProgressView("Loading Animation...")
                        }
                    }
                )
            Spacer()
        }
    }
}

struct ExerciseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseDetailsView(exercise: Exercise(
            name: "Weighted standing curl",
            target: "biceps",
            gifUrl: "https://v2.exercisedb.io/image/tzLIV2Ep5peiAt",
            instructions: ["Stand with your feet shoulder-width apart and hold a dumbbell in each hand, palms facing forward.","Keep your elbows close to your torso and exhale as you curl the weights up to shoulder level.","Pause for a moment at the top, then inhale as you slowly lower the weights back down to the starting position.","Repeat for the desired number of repetitions."]
        ))
    }
}

struct AnimatedImage: UIViewRepresentable {
    let gifURL: URL
    @Binding var isLoading: Bool
    
    func makeUIView(context: UIViewRepresentableContext<AnimatedImage>) -> UIImageView {
        UIImageView()
    }
    
    func updateUIView(_ uiView: UIImageView, context: UIViewRepresentableContext<AnimatedImage>) {
        downloadGif(url: gifURL) { (data) in
            if let data = data {
                uiView.loadGif(data: data) {
                    self.isLoading = false
                }
            }
        }
    }
    
    func downloadGif(url: URL, completion: @escaping (Data?) -> ()) {
        print("Starting download of gif from \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading gif: \(error)")
                completion(nil)
                return
            }
            guard let data = data, error == nil else {
                print("No data received from gif URL")
                completion(nil)
                return
            }
            print("Received gif data of size \(data.count) bytes")
            completion(data)
        }.resume()

    }
}

extension UIImageView {
    func loadGif(data: Data, completion: @escaping () -> Void) {
        guard let image = UIImage.gif(data: data) else { return }
        DispatchQueue.main.async {
            self.image = image
            completion()
        }
    }
}

// Helper extensions to read GIF data and create a UIImage
extension UIImage {
    static func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return UIImage.animatedImageWithSource(source)
    }
    
    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration: TimeInterval = 0
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                duration += frameDurationAtIndex(i, source: source)
                images.append(UIImage(cgImage: image))
            }
        }
        
        return UIImage.animatedImage(with: images, duration: duration)
    }
    
    static func frameDurationAtIndex(_ index: Int, source: CGImageSource!) -> TimeInterval {
        var delay = 0.1
        
        let cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as NSDictionary?
        let gifProperties: NSDictionary? = cfFrameProperties?[kCGImagePropertyGIFDictionary] as? NSDictionary
        
        if let delayObject = gifProperties?[kCGImagePropertyGIFUnclampedDelayTime] {
            delay = delayObject as? Double ?? 0.1
        }
        
        return delay
    }
}
