//
//  GeniusText.swift
//  GeniusWatch Watch App
//
//  Created by James Anyanwu on 29/05/2023.
//

import SwiftUI

struct GeniusText: View {
    var color: Color = .white
    var font: Font = .system(size: 8)
    var title: String
    var value: String
    
    var body: some View {
        VStack {
            Text("\(title): \(value)")
                .foregroundColor(color)
                .font(font)
        }
    }
}
