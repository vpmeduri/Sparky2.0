//
//  MoreInfoView.swift
//  Support
//
//  Created by Jordy Witteman on 13/06/2023.
//

import os
import SwiftUI

struct UpdateView: View {
    
    let logger = Logger(subsystem: "nl.root3.support", category: "SoftwareUpdate")
    
    // Get  computer info from functions in class
    @EnvironmentObject var computerinfo: ComputerInfo
    
    // Get preferences or default values
    @StateObject var preferences = Preferences()
      
    // State of UpdateView popover
    @State private var showPopover: Bool = false
    
    // Update counter
    var updateCounter: Int
            
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            HStack {
                
                Text(updateCounter > 0 ? NSLocalizedString("UPDATES_AVAILABLE", comment: "") : NSLocalizedString("NO_UPDATES_AVAILABLE", comment: ""))
                    .font(.system(.headline, design: .rounded))
                
                Spacer()
                
                Button(action: {
                    showPopover = false
                    openSoftwareUpdate()
                }) {
                    if updateCounter > 0 {
                        Text(NSLocalizedString("UPDATE_NOW", comment: ""))
                    } else {
                        Text(NSLocalizedString("SETTINGS", comment: ""))
                    }
                }
                .modify {
                    if #available(macOS 12, *) {
                        if updateCounter > 0 {
                            $0.buttonStyle(.borderedProminent)
                        } else {
                            $0.buttonStyle(.bordered)
                        }
                    }
                }
            }
            
            Divider()
                .padding(2)
            
            if updateCounter > 0 {
                
                ForEach(computerinfo.recommendedUpdates, id: \.self) { update in
                    
                    Text("•\t\(update.displayName)")
                        .font(.system(.body, design: .rounded))
                    
                }
                
                if preferences.updateText != "" {
                    
                    Divider()
                        .padding(2)
                    
                    HStack {
                        
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                        
                        // Supports for markdown through a variable:
                        // https://blog.eidinger.info/3-surprises-when-using-markdown-in-swiftui
                        Text(.init(preferences.updateText))
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    
                }
            } else {
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                        
                        Text(NSLocalizedString("YOUR_MAC_IS_UP_TO_DATE", comment: ""))
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.medium)
                        
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                        
                    }
                    
                    Spacer()
                    
                }
                
            }
        }
        // Set frame to 250 to allow multiline text
        .frame(width: 300)
        .fixedSize()
        .padding()
        .unredacted()
    }
    
    // Open URL
    func openSoftwareUpdate() {
        
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preferences.softwareupdate") else {
            return
        }

        NSWorkspace.shared.open(url)
        
        // Close the popover
        NSApp.deactivate()

    }
}
