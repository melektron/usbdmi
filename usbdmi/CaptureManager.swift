//
//  CaptureManager.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import AVFoundation

final class CaptureManager: ObservableObject {

    let session = AVCaptureSession()

    func start() throws {
        session.beginConfiguration()
        session.sessionPreset = .high

        guard let device = selectDevice() else {
            throw NSError(domain: "NoDevice", code: -1)
        }

        let input = try AVCaptureDeviceInput(device: device)

        guard session.canAddInput(input) else {
            throw NSError(domain: "InputError", code: -2)
        }

        session.addInput(input)

        session.commitConfiguration()
        session.startRunning()
    }

    private func selectDevice() -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.external, .builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )

        discovery.devices.forEach { print($0.localizedName) }
        return discovery.devices.first
    }
}
