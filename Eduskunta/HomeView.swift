//
//  HomeView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var allMembers: [Member] // Fetch all members data
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.parliamentBlue.opacity(0.4), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Spacer()
                    Text("Suomen Eduskunta")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.parliamentBlue)
                    Image("Flag_of_Finland")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 50)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 80)
                    Image(systemName: "building.columns.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .foregroundStyle(Color.parliamentBlue)
                    // Navigation
                    NavigationLink {
                        PartiesView()
                    } label: {
                        Text("Katso kansanedustajat")
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 220)
                            .background(Color.parliamentBlue)
                            .cornerRadius(25)
                    }
                    Spacer()
                    // Navigation
                    NavigationLink {
                        PartyStatsView(allMembers: allMembers)
                    } label: {
                        Label("Puoluetilastot", systemImage: "chart.bar.fill")
                    }
                }
                .padding()
            }
        }
    }
}

extension Color {
    static let parliamentBlue = Color(red: 0/255, green: 47/255, blue: 108/255)
}

#Preview {
    HomeView()
}
