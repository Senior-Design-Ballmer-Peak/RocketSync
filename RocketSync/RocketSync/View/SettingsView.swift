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
    
    var body: some View {
        VStack {
            Spacer()
            Text("Ballmer Peak Group")
            Text("Version 1.0")
            Spacer()
            
            HStack {
                Image(systemName: "person.crop.rectangle")
                Text("Sign In")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding(.all)
            
            HStack {
                Image(systemName: "lock.fill")
                Text("Sign Out")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding(.all)
            
            HStack {
                Image(systemName: "key.fill")
                Text("Change Password")
                Spacer()
                Image(systemName: "chevron.right")
            }.padding(.all)
            
            HStack {
                Image(systemName: "bell.badge.fill")
                Toggle("Notifications", isOn: $notifications)
            }.padding(.all)
            
            HStack {
                Image(systemName: "sun.max.fill")
                Toggle("Dark Mode", isOn: $darkMode)
            }.padding(.all)
            
            HStack {
                
            }.padding(.all)
        }
    }
}

#Preview {
    SettingsView()
}
