//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Cristiano Calicchia on 18/09/2020.
//  Copyright © 2020 Cristiano Calicchia. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            HStack {
                Image(systemName: "\(row * 4 + col).circle")
                Text("R\(row) C\(col)")
                    .titleStyle()
            }
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.title)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
