//
//  LaunchView.swift
//  MoodScape
//
//

import SwiftUI

struct LaunchView: View {
    @State private var isHidden = false
    
    var body: some View {
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
                }
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}


struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
