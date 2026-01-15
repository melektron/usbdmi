//
//  ContentView.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var captureManager = CaptureManager()

    var body: some View {
        CapturePreview(session: captureManager.session)
            .onAppear {
                do {
                    try captureManager.start()
                } catch {
                    print("Capture error:", error)
                }
            }
            .frame(minWidth: 640, minHeight: 480)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .background(in: .rect, fillStyle: .init())
    }
}

#Preview {
    ContentView()
}
