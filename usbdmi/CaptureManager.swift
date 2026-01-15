//
//  CaptureManager.swift
//  usbdmi
//
//  Created by melektron on 15.01.26.
//

import os
import AVFoundation

final class CaptureManager: NSObject, ObservableObject {

    let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "work.elektron.usbdmi",
        category: "capture"
    )
    
    let session = AVCaptureSession()
    let displayLayer = AVSampleBufferDisplayLayer()

    private let outputQueue = DispatchQueue(
        label: "video.output.queue",
        qos: .userInteractive
    )

    func start() throws {

        guard let device = selectDevice() else {
            throw NSError(domain: "NoDevice", code: -1)
        }

        try configureDevice(device)

        let input = try AVCaptureDeviceInput(device: device)
        
        session.beginConfiguration()
        //session.sessionPreset = .inputPriority   // critical
        session.sessionPreset = .high
        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String:
                kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        ]

        output.alwaysDiscardsLateVideoFrames = true
        output.setSampleBufferDelegate(self, queue: outputQueue)

        session.addOutput(output)

        session.commitConfiguration()
        session.startRunning()
    }

    private func selectDevice() -> AVCaptureDevice? {
        /*AVCaptureDevice.DiscoverySession(
            deviceTypes: [.external],
            mediaType: .video,
            position: .unspecified
        ).devices.first*/
        
        AVCaptureDevice.default(.external, for: .video, position: .unspecified)
    }

    private func configureDevice(_ device: AVCaptureDevice) throws {
        
        logger.info("pre init")
        device.unlockForConfiguration()

        logger.info("pre lock")
        var counter = 0;
        
        repeat {
            do {
                try device.lockForConfiguration()
                Thread.sleep(forTimeInterval: 1.0)
            } catch {
                logger.error("failed to lock device for conf: \(error)")
            }
            counter += 1;
        } while counter < 10;
        
        logger.info("post lock")
        
        if let format = device.formats.first(where: {
            let desc = $0.formatDescription
            let dims = CMVideoFormatDescriptionGetDimensions(desc)
            return dims.width == 1920 &&
                   dims.height == 1080 &&
                   $0.videoSupportedFrameRateRanges.contains {
                       $0.maxFrameRate >= 60
                   }
        }) {
            logger.info("\(format)")
            if let frameRateRange = format.videoSupportedFrameRateRanges.first(where: {
                let fr = $0.maxFrameRate
                return fr >= 60   // only works bc fps of my thing is just above 60 FPS
            }) {
                device.activeFormat = format
                device.activeVideoMinFrameDuration = frameRateRange.minFrameDuration
                device.activeVideoMaxFrameDuration = frameRateRange.minFrameDuration
            } else {
                throw NSError(domain: "NoValidFrameRange", code: -2)
            }
        }

        device.unlockForConfiguration()
        logger.info("post unlock")
    }
}

extension CaptureManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        displayLayer.enqueue(sampleBuffer)
    }
}
