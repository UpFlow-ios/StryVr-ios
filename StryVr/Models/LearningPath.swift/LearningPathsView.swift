//
//  LearningPathsView.swift
//  StryVr
//
//  Created by Joe Dormond on 2/24/25.
//
import SwiftUI

struct LearningPathsView: View {
    @State private var learningPaths: [LearningPath] = [
        LearningPath(title: "iOS Development", progress: 70),
        LearningPath(title: "SwiftUI Mastery", progress: 50),
        LearningPath(title: "AI & Machine Learning", progress: 30)
    ]

    var body: some View {
        NavigationView {
            VStack {
                Text("Learning Paths")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                
                List(learningPaths) { path in
                    LearningPathCard(path: path)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("My Learning Paths")
        }
    }
}

struct LearningPath: Identifiable {
    let id = UUID()
    let title: String
    let progress: Int
}

struct LearningPathCard: View {
    let path: LearningPath

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(path.title)
                .font(.headline)
            
            ProgressBarView(progress: CGFloat(path.progress))
                .frame(height: 10)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.systemBackground)).shadow(radius: 2))
    }
}

struct LearningPathsView_Previews: PreviewProvider {
    static var previews: some View {
        LearningPathsView()
    }
}

