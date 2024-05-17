//
//  StateView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/16.
//

import SwiftUI

struct StateView: View {
    
    @State private var isPlaying = false
    @State private var tapCount = 0
    var body: some View {
        Button {
            // 播放與暫停之間切換
            isPlaying.toggle()
        } label: {
            Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                .font(.system(size: 150))
                .foregroundColor(isPlaying ? .red : .green)
        }
        .padding(.bottom, 30)
        
        Button {
            // 播放與暫停之間切換
            tapCount += 1
        } label: {
            Circle()
                .frame(width: 200, height: 200)
                .foregroundColor(.red)
                .overlay {
                    Text("\(tapCount)")
                        .font(.system(size: 100, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
            
            Text("\(tapCount)")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(.red)
                .cornerRadius(100)
                .frame(minWidth: 0, maxWidth: 100, minHeight: 0, maxHeight: 100)
            
        }
    }
}

#Preview {
    StateView()
}

//struct CounterButton: View {
//    @Binding var counter: Int
//    
//    var color: Color
//    
//    var body: some View {
//        Button {
//            counter += 1
//        } label: {
//            Circle()
//                .frame(width: 200, height: 200)
//                .foregroundColor(.red)
//                .overlay {
//                    Text("\(counter)")
//                        .font(.system(size: 100, weight: .bold, design: .rounded))
//                        .foregroundColor(.white)
//                }
//        }
//    }
//}
