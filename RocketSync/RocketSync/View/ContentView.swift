//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 3/4/24.
//

import SwiftUI

struct ContentView: View {
    @State private var titleAppears = false
    private let animation = Animation.bouncy(duration: 2)
    var showAnimation = false
    @State var selectedTab: Int = 0
    @EnvironmentObject var authModel: AuthenticationModel
    var hasPersistedSignedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    
    var body: some View {
        NavigationStack {
            VStack  {
                if authModel.state == .signedOut && !hasPersistedSignedIn {
                    LoginView()
                } else {
                    switch($selectedTab.wrappedValue){
                    case 0: PostsView()
                    case 1: DistanceMeasureView()
                    case 2: DeviceConnectionView()
                    case 3: ProfileView()
                    case 4: SettingsView()
                    default: PostsView()
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "location.north")
                        .foregroundColor(Color("TextColor"))
                        .id(titleAppears)
                        .transition(PushTransition(edge: .bottom))
                        .onAppear{ titleAppears.toggle() }
                        .animation(animation, value: titleAppears)
                    
                    Text("RocketSync")
                        .font(.title)
                        .fontWidth(.expanded)
                        .foregroundColor(Color("TextColor"))
                        .id(titleAppears)
                        .transition(PushTransition(edge: .top))
                        .animation(animation, value: titleAppears)
                    
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Image(systemName: "gear")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("TextColor"))
                    .onTapGesture { self.selectedTab = 4 }
            }
            
            ToolbarItemGroup(placement: .bottomBar) {
                
                Spacer()
                
                Image(systemName: "aqi.medium")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .opacity(selectedTab == 0 ? 1.0 : 0.4)
                    .disabled(selectedTab == 0)
                    .onTapGesture { self.selectedTab = 0 }
                
                Spacer()
                
                Image(systemName: "scope")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .opacity(selectedTab == 1 ? 1.0 : 0.4)
                    .disabled(selectedTab == 1)
                    .onTapGesture { self.selectedTab = 1 }
                
                Spacer()
                
                Image(systemName: "location.north.line.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .opacity(selectedTab == 2 ? 1.0 : 0.4)
                    .disabled(selectedTab == 2)
                    .onTapGesture { self.selectedTab = 2 }
                
                Spacer()
                
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("TextColor"))
                    .opacity(selectedTab == 3 ? 1.0 : 0.4)
                    .disabled(selectedTab == 3)
                    .onTapGesture { self.selectedTab = 3 }
                
                Spacer()
            }
        }
        .tint(Color("TextColor"))
        .navigationBarTitleDisplayMode(.automatic)
        
    }
}

#Preview {
    ContentView()
}
