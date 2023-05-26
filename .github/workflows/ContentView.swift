//
//  ContentView.swift
//  AdyenAuthenticationTest
//
//  Created by Mohamed Eldoheiri on 26/05/2023.
//

import SwiftUI
import AdyenAuthentication

struct ContentView: View {
    private let service: AuthenticationService = .init(configuration: .init(localizedRegistrationReason: "localizedRegistrationReason",
                                                                            localizedAuthenticationReason: "localizedAuthenticationReason",
                                                                            appleTeamIdentifier: "appleTeamIdentifier"))
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .task {
            do {
                print(try await service.authenticate(withAuthenticationInput: "withAuthenticationInput"))
                print(try await service.register(withRegistrationInput: "withRegistrationInput"))
            } catch {
                print(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
