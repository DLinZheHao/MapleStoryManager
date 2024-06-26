//
//  ListView.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/17.
//

import SwiftUI

struct ListView: View {
    
    var viewModel = ListDataModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.blogs, id: \.id) { blog in
                
                VStack(alignment: .leading) {
                    Image(blog.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                    Text(blog.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                    Text(blog.author)
                    HStack {
                        ForEach(0...blog.star, id: \.self) { _ in
                            Text("*")
                        }
                    }
                    Text(blog.desc)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.gray)
                .listRowInsets(EdgeInsets())
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 0)
            .padding(.top, 10)
            .background(.yellow)
            .listStyle(.plain)
            .navigationTitle("紀錄")
            
        }
        
        // .scrollContentBackground(.hidden)
//        List(viewModel.restaurants, id: \.id) { restaurant in
//            HStack {
//                Image(restaurant.image)
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .cornerRadius(5)
//                Text(restaurant.name)
//            }
//        }
//        /// 符合 Identifiable 才可以這樣寫
//        List(viewModel.restaurants) { restaurant in
//            // BasicImageRow(restaurant: restaurant)
//            FullImageRow(restaurant: restaurant)
//        }
        
    }
}

#Preview {
    ListView()
}

struct BasicImageRow: View {
    
    var restaurant: Restaurant
    
    var body: some View {
        HStack {
            Image(restaurant.image)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(5)
            Text(restaurant.name)
        }
        .listStyle(.plain)
    }
}

struct FullImageRow: View {
    var restaurant: Restaurant
    
    var body: some View {
        ZStack {
            Image(restaurant.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .cornerRadius(10)
                .overlay {
                    Rectangle()
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .opacity(0.2)
                }
            Text(restaurant.name)
                .font(.system(.title, design: .rounded))
                .fontWeight(.black)
                .foregroundColor(.white)
        }
    }
}

