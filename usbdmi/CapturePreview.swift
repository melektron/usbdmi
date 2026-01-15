//
//  CapturePreview.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import SwiftUI
import AVFoundation

struct CapturePreview: NSViewRepresentable {

    let session: AVCaptureSession

    func makeNSView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspect
        return view
    }

    func updateNSView(_ nsView: PreviewView, context: Context) {}
}
