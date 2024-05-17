//
//  CounterView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/17.
//

import SwiftUI

struct CounterView: View {
    
    @State private var counterBlue = 0
    @State private var counterGreen = 0
    @State private var counterRed = 0
    
    var body: some View {
        VStack {
            Text("\(counterBlue + counterGreen + counterRed)")
                .font(.system(size: 220, weight: .bold, design: .rounded))
            
            HStack {
                CounterButton(counter: $counterBlue, color: .blue)
                CounterButton(counter: $counterGreen, color: .green)
                CounterButton(counter: $counterRed, color: .red)
            }
            Button {
                counterBlue += 1
            } label: {
                Text("強制加一")
            }
        }
    }
}

#Preview {
    CounterView()
}

struct CounterButton: View {
    /// 用於雙向綁定 父改子改 子改父也改
    @Binding var counter: Int
    
    var color: Color
    
    var body: some View {
        Button {
            counter += 1
        } label: {
            Circle()
                .frame(width: 120, height: 120)
                .foregroundStyle(color)
                .overlay {
                    Text("\(counter)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
        }
    }
}
