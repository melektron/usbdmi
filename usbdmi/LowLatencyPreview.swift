//
//  LowLatencyPreview.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import SwiftUI
import AVFoundation

struct LowLatencyPreview: NSViewRepresentable {

    let displayLayer: AVSampleBufferDisplayLayer

    func makeNSView(context: Context) -> SampleBufferView {
        let view = SampleBufferView(displayLayer: displayLayer)
        return view
    }

    func updateNSView(_ nsView: SampleBufferView, context: Context) {}
}
