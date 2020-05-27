// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AVFoundation

public class AKRolandTB303FilterAudioUnit: AKAudioUnitBase {

    let cutoffFrequency = AUParameter(
        identifier: "cutoffFrequency",
        name: "Cutoff Frequency (Hz)",
        address: AKRolandTB303FilterParameter.cutoffFrequency.rawValue,
        range: AKRolandTB303Filter.cutoffFrequencyRange,
        unit: .hertz,
        flags: .default)

    let resonance = AUParameter(
        identifier: "resonance",
        name: "Resonance",
        address: AKRolandTB303FilterParameter.resonance.rawValue,
        range: AKRolandTB303Filter.resonanceRange,
        unit: .generic,
        flags: .default)

    let distortion = AUParameter(
        identifier: "distortion",
        name: "Distortion",
        address: AKRolandTB303FilterParameter.distortion.rawValue,
        range: AKRolandTB303Filter.distortionRange,
        unit: .generic,
        flags: .default)

    let resonanceAsymmetry = AUParameter(
        identifier: "resonanceAsymmetry",
        name: "Resonance Asymmetry",
        address: AKRolandTB303FilterParameter.resonanceAsymmetry.rawValue,
        range: AKRolandTB303Filter.resonanceAsymmetryRange,
        unit: .generic,
        flags: .default)

    public override func createDSP() -> AKDSPRef {
        return createRolandTB303FilterDSP()
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)
        
        parameterTree = AUParameterTree.createTree(withChildren: [cutoffFrequency, resonance, distortion, resonanceAsymmetry])
    }
}
