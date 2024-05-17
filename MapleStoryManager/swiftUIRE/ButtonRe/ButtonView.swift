//
//  ButtonView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/15.
//

import SwiftUI

struct ButtonView: View {
    var body: some View {
        ScrollView {
            VStack {
                
                /// 正常的 button
                Button {
                    print("感謝點擊測試用的按鍵，現在給我錢")
                } label: {
                    Text("按我")
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .background(Color.purple)
                        .font(.title)
                }
                .padding(.bottom, 10)
                
                /// 邊匡的 button
                Button {
                    print("感謝點擊測試用的按鍵，給你錢")
                } label: {
                    Text("Hello World!")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .padding()
                        .border(Color.purple, width: 5)
                    
                }
                .padding(.bottom, 10)
                
                /// 圓匡的 button
                Button {
                    print("感謝點擊測試用的按鍵，給你錢")
                } label: {
                    Text("Hello World!")
                        .fontWeight(.bold)
                        .font(.title)
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(40)
                        .foregroundColor(.white)
                        .padding(10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(.purple, lineWidth: 5)
                        }
                }
                .padding(.bottom, 20)
                
                /// 圖片文字組合 button
                Button {
                    print("0.123")
                } label: {
                    Label(
                        title: { Text("Delete")
                                .fontWeight(.semibold)
                            .font(.title) },
                        icon: { Image(systemName: "trash")
                            .font(.title)}
                    )
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
                   
                }
                .padding(.bottom, 20)
                
                /// 漸層背景與陰影按鍵
                Button {
                    print("0.123")
                } label: {
                    Label(
                        title: { Text("Delete")
                                .fontWeight(.semibold)
                            .font(.title) },
                        icon: { Image(systemName: "trash")
                            .font(.title)}
                    )
                    .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
                    .cornerRadius(40)
                    .shadow(color: .gray, radius: 20.0, y: 10)
                   
                }
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    ButtonView()
}
