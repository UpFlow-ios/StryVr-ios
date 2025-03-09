//
//  import SwiftUI

struct SkillTagView: View {
    let skill: String
    
    var body: some View {
        Text(skill)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
    }
}
SkillTagView.swift

