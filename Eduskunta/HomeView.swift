//
//  HomeView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

/* The app's main entry screen showing the Finnish Parliament branding
    and navigation to member lists and party statistics.
 */
struct HomeView: View {
    /*
     All parliament members fetched from the local SwiftData database.
     Automatically updates the view when the database changes.
    */
    @Query private var allMembers: [Member]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient from parliament blue to white
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
                    
                    // Navigates to the full list of members grouped by party
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
                    
                    // Navigates to party statistics, passing all members as data
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

// Extends `Color` with app-specific branding colors.
extension Color {
    static let parliamentBlue = Color(red: 0/255, green: 47/255, blue: 108/255)
}

#Preview {
    HomeView()
}
