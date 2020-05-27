// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit

class AKFaderTests: AKTestCase {

    func testDefault() {
        output = AKFader(input, gain: 1.0)
        AKTestNoEffect()
    }

    func testBypass() {
        let fader = AKFader(input, gain: 2.0)
        fader.bypass()
        output = fader
        AKTestNoEffect()
    }

    func testMany() {
        let initialFader = AKFader(input, gain: 1.0)
        var nextFader = initialFader
        for _ in 0 ..< 200 {
            let fader = AKFader(nextFader, gain: 1.0)
            nextFader = fader
        }
        output = nextFader
        AKTestNoEffect()
    }

    let flippedMD5 = "8c774ff60ef1a5c47f8beec155d25f11"

    func testFlipStereo() {
        let pan = AKPanner(input, pan: 1.0)
        let fader = AKFader(pan, gain: 1.0)
        fader.flipStereo.boolValue = true
        output = fader
        AKTestMD5(flippedMD5)
    }

    func testFlipStereoTwice() {
        let pan = AKPanner(input, pan: 1.0)
        let fader = AKFader(pan, gain: 1.0)
        fader.flipStereo.boolValue = true
        let fader2 = AKFader(fader, gain: 1.0)
        fader2.flipStereo.boolValue = true
        output = fader2
        AKTestMD5("6b75baedc4700e335f665785e8648c14")
    }

    func testFlipStereoThrice() {
        let pan = AKPanner(input, pan: 1.0)
        let fader = AKFader(pan, gain: 1.0)
        fader.flipStereo.boolValue = true
        let fader2 = AKFader(fader, gain: 1.0)
        fader2.flipStereo.boolValue = true
        let fader3 = AKFader(fader2, gain: 1.0)
        fader3.flipStereo.boolValue = true
        output = fader3
        AKTestMD5(flippedMD5)
    }

    func testMixToMono() {
        let pan = AKPanner(input, pan: 1.0)
        let fader = AKFader(pan, gain: 1.0)
        fader.mixToMono.boolValue = true
        output = fader
        AKTestMD5("986675abd9c15378e8f4eb581bf90857")
    }

    func testParameters() {
        output = AKFader(input, gain: 2.0)
        AKTestMD5("09fdb24adb3181f6985eba4b408d8c6d")
    }

    func testParameters2() {
        output = AKFader(input, gain: 0.5)
        AKTestMD5("79972090508032a146d806185f9bc871")
    }
}
