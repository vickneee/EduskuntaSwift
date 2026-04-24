//
//  Rating.swift
//  Eduskunta
//
//  Created by Victoria Vavulina on 24.4.2026.
//

import SwiftData

@Model
class Rating {
    var isPositive: Bool
    var comment: String

    var member: Member?   // relation back

    init(isPositive: Bool, comment: String, member: Member?) {
        self.isPositive = isPositive
        self.comment = comment
        self.member = member
    }
}
