//
//  MemberDetailView.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftUI
import SwiftData

struct MemberDetailView: View {
    let member: Member
    var pictureURL: URL? {
        URL(string: "https://users.metropolia.fi/~peterh/edustajakuvat/\(member.last)-\(member.first)-web-\(member.personNumber).jpg")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: pictureURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.secondary)
                case .empty:
                    ProgressView()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 300, height: 450)
            .clipShape(Rectangle())
            Text("\(member.first) \(member.last)")
                .font(.title)
            Text("Istumapaikka: \(member.seatNumber)")
            Text("Puolue: \(member.party)")
            Text("Vaalipiiri: \(member.constituency)")
            Text("Syntynyt: \(String(member.bornYear))")
            HStack {
                Text("Ministeri:")
                Image(systemName: member.minister ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundStyle(member.minister ? .green : .red)
            }
            if !member.twitter.isEmpty {
                Text("Twitter: \(member.twitter)")
            }
        }
        .padding()
        .navigationTitle("\(member.first) \(member.last)")
    }
}

extension Member {
    static var preview: Member {
        Member(
            personNumber: 1,
            seatNumber: 10,
            last: "Puu",
            first: "Anna",
            party: "ABC",
            minister: false,
            twitter: "",
            bornYear: 1985,
            constituency: "Uusimaa"
        )
    }
}

#Preview {
    MemberDetailView(member: Member.preview)
        .modelContainer(for: Member.self, inMemory: true)
}
