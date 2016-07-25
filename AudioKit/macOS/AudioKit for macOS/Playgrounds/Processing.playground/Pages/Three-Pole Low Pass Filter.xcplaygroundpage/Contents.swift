//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
//:
//: ---
//:
//: ## Three-Pole Low Pass Filter
//: ##
import XCPlayground
import AudioKit

let file = try AKAudioFile(readFileName: "mixloop.wav", baseDir: .Resources)

let player = try AKAudioPlayer(file: file)
player.looping = true
var filter = AKThreePoleLowpassFilter(player)

//: Set the parameters of the Moog Ladder Filter here.
filter.cutoffFrequency = 300 // Hz
filter.resonance = 0.6
filter.rampTime = 0.1

AudioKit.output = filter
AudioKit.start()

player.play()

//: User Interface Set up
class PlaygroundView: AKPlaygroundView {

    var cutoffFrequencyLabel: Label?
    var resonanceLabel: Label?

    override func setup() {
        addTitle("Three Pole Low Pass Filter")

        addButtons()

        cutoffFrequencyLabel = addLabel("Cutoff Frequency: \(filter.cutoffFrequency)")
        addSlider(#selector(setCutoffFrequency),
                  value: filter.cutoffFrequency,
                  minimum: 0,
                  maximum: 5000)

        resonanceLabel = addLabel("Resonance: \(filter.resonance)")
        addSlider(#selector(setResonance),
                  value: filter.resonance,
                  minimum: 0,
                  maximum: 0.99)
    }

    override func startLoop(name: String) {
        player.stop()
        let file = try? AKAudioFile(readFileName: "\(name)", baseDir: .Resources)
        try? player.replaceFile(file!)
        player.play()
    }

    override func stop() {
        player.stop()
    }

    func setCutoffFrequency(slider: Slider) {
        filter.cutoffFrequency = Double(slider.value)
        cutoffFrequencyLabel!.text = "Cutoff Frequency: " +
            String(format: "%0.0f", filter.cutoffFrequency)
    }

    func setResonance(slider: Slider) {
        filter.resonance = Double(slider.value)
        resonanceLabel!.text = "Resonance: \(String(format: "%0.3f", filter.resonance))"
    }
}

let view = PlaygroundView(frame: CGRect(x: 0, y: 0, width: 500, height: 300))
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
XCPlaygroundPage.currentPage.liveView = view

//: [TOC](Table%20Of%20Contents) | [Previous](@previous) | [Next](@next)
