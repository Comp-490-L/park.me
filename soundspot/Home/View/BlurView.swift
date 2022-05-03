//
//  BlurView.swift
//  soundspot
//
//  Created by James Maturino on 5/3/22.
//

import Foundation
import SwiftUI

struct BlurView: UIViewRepresentable
{
    func makeUIView(context: Context) -> UIVisualEffectView
    {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context)
    {
        
    }
}
