//
//  FilteredList.swift
//  CoreDataProject
//
//  Created by Cristiano Calicchia on 22/10/2020.
//

import SwiftUI
import CoreData

/* Generic

struct FilteredList<T: NSManagedObject, Content: View>: View {
    var fetchRequest: FetchRequest<T>
    var singers: FetchedResults<T> { fetchRequest.wrappedValue }

    // this is our content closure; we'll call this once for each item in the list
    let content: (T) -> Content

    var body: some View {
        List(fetchRequest.wrappedValue, id: \.self) { singer in
            self.content(singer)
        }
    }

    init(filterKey: String, filterValue: String, @ViewBuilder content: @escaping (T) -> Content) {
        fetchRequest = FetchRequest<T>(entity: T.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K BEGINSWITH %@", filterKey, filterValue))
        self.content = content
    }
}*/

/* Non-generic */

struct FilteredList: View {
    var fetchRequest: FetchRequest<Singer>
    var singers: FetchedResults<Singer> { fetchRequest.wrappedValue }
    enum Predicates {
        case beginsWith
        case contains
    }
    
    var body: some View {
        List(singers, id: \.self) { singer in
            Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
        }
    }
    
    init(filter: String, predicate: Predicates) {
        var myPredicate : String
        switch predicate {
        case .beginsWith:
            myPredicate = "BEGINSWITH"
        case .contains:
            myPredicate = "CONTAINS[c]"
        }
        fetchRequest = FetchRequest<Singer>(entity: Singer.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Singer.firstName, ascending: true),NSSortDescriptor(keyPath: \Singer.lastName, ascending: true)], predicate: NSPredicate(format: "lastName \(myPredicate) %@", filter))
    }
    
}
