//
//  ContentView.swift
//  BucketList
//
//  Created by Cristiano Calicchia on 27/10/2020.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    @State private var authetincateErrors = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    
    var body: some View {
        ZStack {
            if isUnlocked {
                MainView()
            } else {
                Button("Unlock Places") {
                    self.authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $authetincateErrors) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        errorTitle = "Failed to authenticate"
                        errorMessage = "Non-matching face!"
                        self.authetincateErrors = true
                    }
                }
            }
        } else {
            errorTitle = "No authenticate feature"
            errorMessage = "Your device doesn't support FaceID nor TouchID"
            self.authetincateErrors = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
