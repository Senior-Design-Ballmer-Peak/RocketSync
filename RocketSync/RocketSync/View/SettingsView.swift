//
//  SettingsView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 2/26/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var darkMode = false
    @State private var notifications = false
    @EnvironmentObject var authModel: AuthenticationModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Ballmer Peak Group")
            Text("Version 1.0")
            Spacer()
            
            HStack {
                Button(action: {
                    authModel.signOut()
                }, label: {
                    Image(systemName: "lock.fill")
                    Text("Sign Out")
                    Spacer()
                    Image(systemName: "chevron.right")
                })
                .padding(.all)
            }
            
            HStack {
                
            }.padding(.all)
        }
    }
}

#Preview {
    SettingsView()
}
