//
//  AstronautView.swift
//  Moonshot
//
//  Created by Cristiano Calicchia on 28/09/2020.
//

import SwiftUI

struct AstronautView: View {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronaut: Astronaut
    var astronautMissions = [String]()

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                    
                    Text("Missions he took part of:")
                        .font(.headline)
                        .padding()
                    
                    ForEach(0..<astronautMissions.count) {mission in
                        
                        Text("\(astronautMissions[mission])")
                        
                    }
                    
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut) {
        
        for mission in missions {
            for member in mission.crew {
                if member.name == astronaut.id {
                    astronautMissions.append("Apollo \(mission.id)")
                    break
                }
            }
        }
        
        self.astronaut = astronaut
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
