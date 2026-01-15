//
//  SampleBufferView.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import AppKit
import AVFoundation

final class SampleBufferView: NSView {

    init(displayLayer: AVSampleBufferDisplayLayer) {
        super.init(frame: .zero)
        wantsLayer = true
        layer = displayLayer

        displayLayer.videoGravity = .resizeAspect
        displayLayer.controlTimebase = nil   // critical for low latency
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}
