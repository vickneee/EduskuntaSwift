//
//  MemberNote.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import Foundation
import SwiftData

@Model
class MemberNote {
    var memberPersonNumber: Int
    var text: String
    var isPositive: Bool
    var date: Date
    
    init(memberPersonNumber: Int, text: String, isPositive: Bool) {
        self.memberPersonNumber = memberPersonNumber
        self.text = text
        self.isPositive = isPositive
        self.date = Date()
    }
}
