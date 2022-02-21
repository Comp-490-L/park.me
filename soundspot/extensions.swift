//
//  extensions.swift
//  soundspot
//
//  Created by Yassine Regragui on 2/18/22.
//

import Foundation
import SwiftUI

extension Color {
    static let backgroundColor = Color("BackgroundColor")
}


struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }
}


extension View {
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(perform: action))
    }
}
