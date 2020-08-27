// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import Foundation
import AVFoundation
import CAudioKit
import soundpipe

extension AKManager {
    // MARK: - Testing

    /// Test the output of a given node
    ///
    /// - Parameters:
    ///   - node: AKNode to test
    ///   - duration: Number of seconds to test (accurate to the sample)
    ///   - afterStart: Closure to execute at the beginning of the test
    ///
    /// - Returns: MD5 hash of audio output for comparison with test baseline.
    public static func test(node: AKNode, duration: Double, afterStart: () -> Void = {}) throws -> String {

        var digestHex = ""

        #if swift(>=3.2)
        if #available(iOS 11, macOS 10.13, tvOS 11, *) {
            let samples = Int(duration * AKSettings.sampleRate)

            output = node

            // maximum number of frames the engine will be asked to render in any single render call
            let maximumFrameCount: AVAudioFrameCount = 4_096
            try AKTry {
                engine.reset()
                try engine.enableManualRenderingMode(.offline,
                                                     format: AKSettings.audioFormat,
                                                     maximumFrameCount: maximumFrameCount)
                try engine.start()
            }

            afterStart()

            let md5state = UnsafeMutablePointer<md5_state_s>.allocate(capacity: 1)
            md5_init(md5state)
            var samplesHashed = 0

            guard let buffer = AVAudioPCMBuffer(
                pcmFormat: engine.manualRenderingFormat,
                frameCapacity: engine.manualRenderingMaximumFrameCount) else { return "" }

            while engine.manualRenderingSampleTime < samples {
                let framesToRender = buffer.frameCapacity
                let status = try engine.renderOffline(framesToRender, to: buffer)
                switch status {
                case .success:
                    // data rendered successfully
                    if let floatChannelData = buffer.floatChannelData {

                        for frame in 0 ..< framesToRender {
                            for channel in 0 ..< buffer.format.channelCount where samplesHashed < samples {
                                let sample = floatChannelData[Int(channel)][Int(frame)]
                                withUnsafeBytes(of: sample) { samplePtr in
                                    if let baseAddress = samplePtr.bindMemory(to: md5_byte_t.self).baseAddress {
                                        md5_append(md5state, baseAddress, 4)
                                    }
                                }
                                samplesHashed += 1
                            }
                        }

                    }

                case .insufficientDataFromInputNode:
                    // applicable only if using the input node as one of the sources
                    break

                case .cannotDoInCurrentContext:
                    // engine could not render in the current render call, retry in next iteration
                    break

                case .error:
                    // error occurred while rendering
                    fatalError("render failed")
                @unknown default:
                    fatalError("Unknown render result")
                }
            }

            var digest = [md5_byte_t](repeating: 0, count: 16)

            digest.withUnsafeMutableBufferPointer { digestPtr in
                md5_finish(md5state, digestPtr.baseAddress)
            }

            for index in 0..<16 {
                digestHex += String(format: "%02x", digest[index])
            }

            md5state.deallocate()

        }
        #endif

        return digestHex
    }

    /// Audition the test to hear what it sounds like
    ///
    /// - Parameters:
    ///   - node: AKNode to test
    ///   - duration: Number of seconds to test (accurate to the sample)
    ///
    public static func auditionTest(node: AKNode, duration: Double, afterStart: () -> Void = {}) throws {
        output = node

        let isRunning = AKManager.engine.isRunning

        // AKLog("AKManager.engine.isRunning", isRunning)

        try start()

        // if the engine isn't running you need to give it time to get its act together before
        // playing, otherwise the start of the audio is cut off
        if !isRunning {
            usleep(UInt32(1_000_000))
        }

        afterStart()
        if let playableNode = node as? AKToggleable {
            playableNode.play()
        }
        usleep(UInt32(duration * 1_000_000))
        try stop()
        try start()
    }

}
