//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Cristiano Calicchia on 04/11/2020.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @State private var isShowingScanner = false
    @State private var showingActionSheet = false
    @State private var isSorted = false
    @EnvironmentObject var prospects: Prospects
    enum FilterType {
        case none, contacted, uncontacted
    }
    let filter: FilterType
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            if isSorted {
                return prospects.people.sorted()
            } else {
                return prospects.people
            }
        case .contacted:
            if isSorted {
                return prospects.people.filter { $0.isContacted }.sorted()
            } else {
                return prospects.people.filter { $0.isContacted }
            }
        case .uncontacted:
            if isSorted {
                return prospects.people.filter { !$0.isContacted }.sorted()
            } else {
                return prospects.people.filter { !$0.isContacted }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted" ) {
                                self.prospects.toggle(prospect)
                            }
                            if !prospect.isContacted {
                                Button("Remind Me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                        }
                        
                        if filter == .none {
                            if prospect.isContacted {
                                Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                    .padding()
                            } else {
                                Image(systemName: "person.crop.circle.badge.checkmark")
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        self.isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    }
                    
                    Button(action: {
                    self.showingActionSheet = true
                    }) {
                        Image(systemName: "list.bullet")
                    }
                })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: self.handleScan)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(title: Text("Order by:"), message: Text("Choose an order"), buttons: [
                    .default(Text("Name")) { isSorted = true },
                    .default(Text("Most recent")) { isSorted = false },
                    .cancel()
                ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            self.prospects.add(person)
        case .failure(let error):
            print("Scanning failed")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponents = DateComponents()
            dateComponents.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
             
            /*For test
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)*/

            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
