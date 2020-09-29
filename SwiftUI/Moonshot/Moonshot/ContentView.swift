//
//  ContentView.swift
//  Moonshot
//
//  Created by Cristiano Calicchia on 28/09/2020.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var showCrew = false
    @State private var subtitle = ""
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        Text(showCrew ? calculateCrew(mission: mission) : mission.formattedLaunchDate)
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(trailing: Button("Change view") {
                showCrew.toggle()
            })
        }
    }
    
    func calculateCrew(mission: Mission) -> String {
        var crewArray = [String]()
        for member in mission.crew {
            crewArray.append(member.name)
        }
        return crewArray.joined(separator: ",")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
