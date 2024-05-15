//
//  SwiftUIViewController.swift
//  MapleStoryManager
//
//  Created by LinZheHao on 2024/5/10.
//

import UIKit
import SwiftUI
class SwiftUIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let swiftUIView = SwiftUIView()
        
        // Create a UIHostingController to host the SwiftUI button
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add the hosting controller's view to the view hierarchy
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
    }
    
}
