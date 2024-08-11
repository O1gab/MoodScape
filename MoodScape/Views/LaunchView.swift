//
//  LaunchView.swift
//  MoodScape
//
//

import SwiftUI

struct LaunchView: View {
    @State private var isHidden = false
    
    var body: some View {
        NavigationView {
                    VStack {
                        Spacer()
                        Text("MoodScape")
                            .font(.system(size: 37, weight: .bold))
                            .foregroundColor(Color(red: 30/255, green: 215/255, blue: 96/255))
                            .opacity(isHidden ? 0.0 : 1.0)
                            .onAppear {
                                withAnimation(Animation.easeInOut(duration: 3.0)) {
                                    isHidden = true
                                }
                                // Delay the navigation to LoginView by the duration of the animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    navigateToLogin = true
                                }
                            }
                        Spacer()
                        // Navigate to LoginView when navigateToLogin is true
                        NavigationLink(destination: LoginView(), isActive: $navigateToLogin) {
                            EmptyView()
                        }
                    }
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                }
            }
}

private extension LaunchView {
    func nextView() {
        let loginView = LoginView()
        // go to the login view after launchview
        
    }
}


struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
