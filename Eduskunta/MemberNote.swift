//
//  MemberNote.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation
import SwiftData

/*
A persistent model representing a user's note about a parliament member.
 
Stored locally using SwiftData (`@Model`).
Each note is linked to a member via `memberPersonNumber`.
*/
@Model
class MemberNote {
    var memberPersonNumber: Int
    var text: String
    var isPositive: Bool
    var date: Date
    
    /* Creates a new note linked to a parliament member.
        - Parameters:
            - memberPersonNumber: The unique identifier of the member being noted.
            - text: The content of the note.
            - isPositive: `true` if the note is positive, `false` if negative.
        - Note: `date` is set automatically to the current date and time.
     */
    init(memberPersonNumber: Int, text: String, isPositive: Bool) {
        self.memberPersonNumber = memberPersonNumber
        self.text = text
        self.isPositive = isPositive
        self.date = Date()
    }
}
