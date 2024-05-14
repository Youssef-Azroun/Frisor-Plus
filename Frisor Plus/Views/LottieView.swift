//
//  LottieView.swift
//  Frisor Plus
//
//  Created by Kanyaton Somjit on 2024-05-14.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: "confeti")
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
        
    }

}
