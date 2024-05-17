//
//  ScrollContentView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/15.
//

import SwiftUI

struct ScrollContentView: View {
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text("MONDAY, AUG 20")
                        .font(Font(UIFont.iOS_font14()))
                        .foregroundColor(.gray)
                    Text("Your Reading")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding([.horizontal])
            
            VStack {
                CardView(image: "swiftui-button", category: "SwiftUI", heading: "Drawing a Border with Rounded Corners", author: "Simon Ng")
                CardView(image: "macos-programming", category: "macOS", heading: "Building a Simple Editing App", author: "Gabriel Theodoropoulos")
                CardView(image: "flutter-app", category: "Flutter", heading: "Building a Complex Layout with Flutter", author: "Lawrence Tan")
                CardView(image: "natural-language-api", category: "iOS", heading: "What's New in Natural Language API", author: "Sai Kambampati")
            }
        }
    }
}

#Preview {
    ScrollContentView()
}
