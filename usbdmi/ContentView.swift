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
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            CapturePreview(session: captureManager.session)
                .onAppear {
                    do {
                        try captureManager.start()
                    } catch {
                        print("Capture error:", error)
                    }
                }
                .frame(minWidth: 640, minHeight: 480)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
