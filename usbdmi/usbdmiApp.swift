//
//  usbdmiApp.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import SwiftUI

@main
struct usbdmiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .background(WindowAccessor { window in
                    // Make the window fullscreen as soon as it appears
                    DispatchQueue.main.async {
                        window.toggleFullScreen(nil)
                    }
                })
                .onHover { isHovering in
                    if isHovering {
                        NSCursor.hide()
                    } else {
                        NSCursor.unhide()
                    }
                    
                }
        }
    }
}

// Helper view to get NSWindow
struct WindowAccessor: NSViewRepresentable {
    var callback: (NSWindow) -> Void

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                callback(window)
            }
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
