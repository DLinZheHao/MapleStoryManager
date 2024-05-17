//
//  SwiftUIView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/9.
//
// 這一頁簡單展示如何擺放介面，並且讓 view 可以重複利用
import SwiftUI

struct SwiftUIView: View {
    
    var body: some View {
        VStack {
            HeaderView()
            HStack(spacing: 15) {
                PriceingView(title: "Basic", price: "$9", textColor: .white, bgColor: .purple)
                DescPriceView(title: "Pro", price: "$19", desc: "Best for designer", textColor: .white, bgColor: .blue, offestY: 87)
            }
            .padding(10)
            
            DescPriceView(title: "Team", price: "$299", desc: "Perfect for teams with 20 members", textColor: .white, bgColor: .gray, offestY: 110, icon: "wand.and.rays")
                .padding(10)
            
            Spacer()
        }
    }
}

struct HelloWorldView: View {
    @State var desc = ""
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .foregroundColor(
                    Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0))
            
            if !desc.isEmpty {
                Text(desc)
            }
            
            Button() {
                desc = "出現了!"
            } label: {
                Text("我是按鈕")
            }
            .font(Font(UIFont.iOS_font14()))
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .animation(.easeInOut, value:  desc)
    }
}

#Preview {
    SwiftUIView()
}

struct HeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("choose")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                Text("Your Plan")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding()
    }
}

struct PriceingView: View {
    
    var title: String
    var price: String
    var textColor: Color
    var bgColor: Color
    var icon: String?
    
    var body: some View {
        VStack {
            if let icon = icon, !icon.isEmpty {
                Image(systemName: icon)
                    .font(.largeTitle)
                    .foregroundColor(textColor)
            }
            
            Text(title)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(textColor)
            Text(price)
                .font(.system(size: 40, weight: .heavy, design: .rounded))
                .foregroundColor(textColor)
            Text("per month")
                .font(.headline)
                .foregroundColor(textColor)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100)
        .padding(40)
        .background(bgColor)
        .cornerRadius(10)
    }
    
}

struct DescPriceView: View {
    
    var title: String
    var price: String
    var desc: String
    var textColor: Color
    var bgColor: Color
    var offestY: CGFloat
    var icon: String?
    
    
    var body: some View {
        ZStack {
            PriceingView(title: title, price: price, textColor: textColor, bgColor: bgColor, icon: icon ?? "")
            
            Text(desc)
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(5)
                .background(Color(red: 255/255, green: 183/255, blue: 37/255))
                .offset(x: 0 ,y: offestY)
        }
    }
}


// 如果有重複的物件調整風格，隔一單獨開一個調整器出來（以下是範例）
struct MineTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8).strokeBorder(Color.blue, lineWidth: 2))
            .padding(.horizontal)
    }
}


//struct TextStyle: ViewModifier {
//    func body(content: Content) -> some View {
//        return content.
//            .
//            .
//    }
//}
