//
//  CustomNavigationView.swift
//  StryVr
//
//  Created by Joe Dormond on 3/5/25.
//
import SwiftUI

struct CustomNavigationView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("StryVr Navigation")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityLabel("StryVr Navigation Title")
                NavigationLink(destination: Text("Next Screen")) {
                    Text("Go to Next Screen")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .accessibilityLabel("Go to Next Screen Button")
                }
                Spacer()
            }
        }
    }
}

struct CustomNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationView()
    }
}
