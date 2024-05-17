//
//  ListDataModel.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/17.
//

import Foundation
import SwiftUI

class ListDataModel {
    
    var restaurants = [ Restaurant(name: "Cafe Deadend", image: "cafedeadend"),
                        Restaurant(name: "Homei", image: "homei"),
                        Restaurant(name: "Teakha", image: "teakha"),
                        Restaurant(name: "Cafe Loisl", image: "cafeloisl"),
                        Restaurant(name: "Petite Oyster", image: "petiteoyster"), 
                        Restaurant(name: "For Kee Restaurant", image: "forkeerestaurant"),
                        Restaurant(name: "Po's Atelier", image: "posatelier"),
                        Restaurant(name: "Bourke Street Bakery", image: "bourkestreetbakery"),
                        Restaurant(name: "Haigh's Chocolate", image: "haighschocolate"),
                        Restaurant(name: "Palomino Espresso", image: "palominoespresso"),
                        Restaurant(name: "Upstate", image: "upstate"),
                        Restaurant(name: "Traif", image: "traif"),
                        Restaurant(name: "Graham Avenue Meats And Deli", image: "grahamaven"),
                        Restaurant(name: "Waffle & Wolf", image: "wafflewolf"),
                        Restaurant(name: "Five Leaves", image: "fiveleaves"),
                        Restaurant(name: "Cafe Lore", image: "cafelore"),
                        Restaurant(name: "Confessional", image: "confessional"),
                        Restaurant(name: "Barrafina", image: "barrafina"),
                        Restaurant(name: "Donostia", image: "donostia"),
                        Restaurant(name: "Royal Oak", image: "royaloak"),
                        Restaurant(name: "CASK Pub and Kitchen", image: "caskpubkitchen")
    ]
    
    
    var blogs = [ Blog(image: "flutter-app", title: "第一篇文章", author: "我肚子好餓", star: 4, desc: "我想要吃飯我想要吃飯我想要吃飯我想要吃飯我想要吃飯"),
                  Blog(image: "flutter-app", title: "第一篇文章", author: "我肚子好餓", star: 4, desc: "我想要吃飯我想要吃飯我想要吃飯我想要吃飯我想要吃飯"),
                  Blog(image: "flutter-app", title: "第一篇文章", author: "我肚子好餓", star: 4, desc: "我想要吃飯我想要吃飯我想要吃飯我想要吃飯我想要吃飯"),
                  Blog(image: "flutter-app", title: "第一篇文章", author: "我肚子好餓", star: 4, desc: "我想要吃飯我想要吃飯我想要吃飯我想要吃飯我想要吃飯"),
                  Blog(image: "flutter-app", title: "第一篇文章", author: "我肚子好餓", star: 4, desc: "我想要吃飯我想要吃飯我想要吃飯我想要吃飯我想要吃飯"),
    ]
}

struct Restaurant: Identifiable {
    var id = UUID()
    var name: String
    var image: String
}

struct Blog: Identifiable {
    var id = UUID()
    var image: String
    var title: String
    var author: String
    var star: Int
    var desc: String
}

//struct Restaurant {
//    var id = UUID()
//    var name: String
//    var image: String
//}
