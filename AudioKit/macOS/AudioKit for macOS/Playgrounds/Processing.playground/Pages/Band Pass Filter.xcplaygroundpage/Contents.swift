//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Band Pass Filter
//: ### Band-pass filters allow audio above a specified frequency range and
//: ### bandwidth to pass through to an output. The center frequency is the starting point
//: ### from where the frequency limit is set. Adjusting the bandwidth sets how far out
//: ### above and below the center frequency the frequency band should be.
//: ### Anything above that band should pass through.
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: "mixloop.wav", baseDir: .Resources)

let player = try AKAudioPlayer(file: file)
player.looping = true

//: Next, we'll connect the audio sources to a band pass filter
var bandPassFilter = AKBandPassFilter(player)

//: Set the parameters of the band pass filter here
bandPassFilter.centerFrequency = 5000 // Hz
bandPassFilter.bandwidth = 600  // Cents

AudioKit.output = bandPassFilter
AudioKit.start()

//: User Interface Set up

class PlaygroundView: AKPlaygroundView {

    //: UI Elements we'll need to be able to access
    var centerFrequencyLabel: Label?
    var bandwidthLabel: Label?

    override func setup() {
        addTitle("Band Pass Filter")

        addButtons()

        addLabel("Band Pass Filter Parameters")

        addButton("Process", action: #selector(process))
        addButton("Bypass", action: #selector(bypass))

        centerFrequencyLabel = addLabel("Center Frequency: \(bandPassFilter.centerFrequency) Hz")
        addSlider(#selector(setCenterFrequency),
                  value: bandPassFilter.centerFrequency,
                  minimum: 20,
                  maximum: 22050)

        bandwidthLabel = addLabel("Bandwidth \(bandPassFilter.bandwidth) Cents")
        addSlider(#selector(setBandwidth),
                  value: bandPassFilter.bandwidth,
                  minimum: 100,
                  maximum: 12000)
    }

    //: Handle UI Events

    override func startLoop(name: String) {
        player.stop()
        let file = try? AKAudioFile(readFileName: "\(name)", baseDir: .Resources)
        try? player.replaceFile(file!)
        player.play()
    }
    override func stop() {
        player.stop()
    }

    func process() {
        bandPassFilter.play()
    }

    func bypass() {
        bandPassFilter.bypass()
    }

    func setCenterFrequency(slider: Slider) {
        bandPassFilter.centerFrequency = Double(slider.value)
        let frequency = String(format: "%0.1f", bandPassFilter.centerFrequency)
        centerFrequencyLabel!.text = "Center Frequency: \(frequency) Hz"
    }

    func setBandwidth(slider: Slider) {
        bandPassFilter.bandwidth = Double(slider.value)
        let bandwidth = String(format: "%0.1f", bandPassFilter.bandwidth)
        bandwidthLabel!.text = "Bandwidth: \(bandwidth) Cents"
    }

}


let view = PlaygroundView(frame: CGRect(x: 0, y: 0, width: 500, height: 550))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = view

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
