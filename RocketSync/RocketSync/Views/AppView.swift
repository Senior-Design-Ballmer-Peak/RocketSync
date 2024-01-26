//
//  ContentView.swift
//  RocketSync
//
//  Created by Trey Eckenrod on 1/18/24.
//

import SwiftUI
import SwiftData

struct AppView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State var selection : Int = 0
    
    var body: some View {
        VStack {
            HStack {
                Text("RocketSync")
                    .padding(.leading)
                    .bold()
                    .font(.largeTitle)
                Spacer()
            }
            
            TabView(selection: $selection) {
                PostTableView().tabItem { Text("Social Tab") }.tag(0)
                DistanceMeasureView().tabItem { Text("GPS Tab") }.tag(1)
                Text("Launch").tabItem { Text("Launch Tab") }.tag(2)
                Text("Profile").tabItem { Text("Profile Tab") }.tag(3)
                SettingsView().tabItem { Text("Settings Tab") }.tag(4)
            }
            .overlay(
                Color.white
                    .edgesIgnoringSafeArea(.vertical)
                    .frame(height: 50)
                    .overlay(HStack {
                        Spacer()
                        Button(action: {
                            self.selection = 0
                        }, label: {
                            Image(systemName: "aqi.medium")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 0 ? 1 : 0.4)
                        })
                        Spacer()
                        
                        Button(action: {
                            self.selection = 1
                        }, label: {
                            Image(systemName: "scope")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 1 ? 1 : 0.4)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.selection = 2
                        }, label: {
                            ZStack {
                                Circle()
                                    .frame(width: 100, height: 100, alignment: .center)
                                    .foregroundColor(.white)
                                Image(systemName: "location.north.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60, height: 60, alignment: .center)
                                    .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 2 ? 1 : 0.4)
                            }
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.selection = 3
                        }, label: {
                            Image(systemName: "person.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 3 ? 1 : 0.4)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            self.selection = 4
                        }, label: {
                            Image(systemName: "gear")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30, alignment: .center)
                                .foregroundColor(Color(red: 32/255, green: 43/255, blue: 63/255))
                                .opacity(selection == 4 ? 1 : 0.4)
                        })
                        
                        Spacer()
                    })
                ,alignment: .bottom)
        }
    }
}

#Preview {
    AppView()
}
