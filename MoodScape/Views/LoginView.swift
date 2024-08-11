//
//  LoginView.swift
//  MoodScape
//
//  Created by Olga Batiunia on 10.08.24.
//

import SwiftUI
import Gifu


struct LoginView: View {
    @State private var isRegistering = false
    
    var loginViewController = LoginViewController()
    

    var body: some View {
        ZStack {
            // Background GIF
            GIFBackgroundView(gifName: "gradient_skyline_blinking_stars")
                            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                // Label
                Text("MoodScape")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 30/255, green: 215/255, blue: 96/255))
                   

                Spacer()

                // Buttons
                VStack(spacing: 20) {
                    Button(action: {
                        handleLogin()
                    }) {
                        Text("Login")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 250, height: 55)
                            .background(Color(red: 30/255, green: 215/255, blue: 96/255))
                            .cornerRadius(25)
                    }

                    Button(action: {
                        handleRegister()
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 250, height: 55)
                            .background(Color(red: 30/255, green: 215/255, blue: 96/255))
                            .cornerRadius(25)
                    }
                }
                Spacer()
                Spacer()
            }
        }
    }

    // Example actions for buttons
    private func handleRegister() {
        print("Sign up button tapped")
    }

    private func handleLogin() {
        print("Login button tapped")
    }
}

// Custom view for GIF background
struct GIFBackgroundView: UIViewRepresentable {
    
    let gifName: String
    
    func makeUIView(context: Context) -> GIFImageView {
        let gifImageView = GIFImageView()
        gifImageView.animate(withGIFNamed: gifName)
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.translatesAutoresizingMaskIntoConstraints = false
        gifImageView.clipsToBounds = true
        return gifImageView
    }
    
    func updateUIView(_ uiView: Gifu.GIFImageView, context: Context) {
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

