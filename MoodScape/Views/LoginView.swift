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
            BackgroundView()
                .edgesIgnoringSafeArea(.all)

            VStack {
             
                // Label
                Text("MoodScape")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 30/255, green: 215/255, blue: 96/255))
                    .padding()

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
        // Handle register action
    }

    private func handleLogin() {
        // Handle login action
    }
}

// Custom view for GIF background
struct BackgroundView: View {
    let gifImageView = GIFImageView()
    
    var body: some View {
        VStack {
        }
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

