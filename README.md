# USBDMI

USB-Definition-Media-Interface

A tiny SwiftUI app that I use to display the output of a USB capture card (1080p, 60fps) on a full-screen window to use my iMac as an (admittedly terrible) monitor.

> ^ terrible not because of the iMac display, but because of the USB capture card

The code is mostly cobbled together from ChatGPT and Stackoverflow snippets, so don't expect to find any amazing implementation.

I am simply using an `AVCaptureVideoPreviewLayer` to display the output of a capture session in a window. No fancy hight-performance direct Metal implementation.
The input device is configured to it's 1080p 60fps video format. 
For some reason, my capture card device fails to be locked  using `lockForConfiguration` immediately after instantiation, which is the reason for the blocking loop of repeated locking attempts.

