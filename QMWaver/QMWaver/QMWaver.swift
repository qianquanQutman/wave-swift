//
//  QMWaver.swift
//  QMWaver
//
//  Created by 钱权 on 2019/2/25.
//  Copyright © 2019 tianyuantechnology.com. All rights reserved.
//

import UIKit

typealias LevelCallBack = (QMWaver) -> (Void)

class QMWaver: UIView {
    
    var numberOfWaves: Int = 5
    var waveColor = UIColor.white
    var level: CGFloat?{
        didSet{
            phase += phaseShift
            amplitude = fmax(level!, idleAmplitude)
            updateMeters()
        }
    }
    var waveLevelCallBack:LevelCallBack?{
        didSet{
            startWave()
        }
    }
    
    var mainWaveWidth: CGFloat = 2.0
    var idleAmplitude: CGFloat = 0.01
    var frequency: CGFloat = 1.2
    var amplitude: CGFloat = 1.0
    var density: CGFloat = 1.0
    var phaseShift: CGFloat = -0.25
    var waves: [CAShapeLayer] = []
    var decorativeWavesWidth: CGFloat = 1.0
    
    
    var phase: CGFloat = 0
    var waveHeight: CGFloat = 0
    var waveWidth: CGFloat = 0
    var waveMid: CGFloat = 0
    var maxAmplitude: CGFloat = 0
    
    var displayLink: CADisplayLink? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        waveHeight = bounds.size.height
        waveWidth = bounds.size.width
        waveMid = waveWidth * 0.5
        maxAmplitude = waveHeight - 4.0
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWave() -> Void {
        displayLink?.invalidate()
        displayLink = CADisplayLink.init(target: self, selector: #selector(self.incokeWaveCallBack))
        displayLink?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
        
        for i in 0..<numberOfWaves {
            let waveLine = CAShapeLayer.init()
            waveLine.lineCap = .butt
            waveLine.lineJoin = .round
            waveLine.strokeColor = UIColor.clear.cgColor
            waveLine.fillColor = UIColor.clear.cgColor
            var color: UIColor? = nil
            let progress: CGFloat = 1.0 - CGFloat(integerLiteral: i) / CGFloat(integerLiteral: numberOfWaves)
            let multiplier: CGFloat = CGFloat.minimum(1.0, (progress / 3.0 * 2.0) + (1.0 / 3.0))
            
            if 0 == i{
                waveLine.lineWidth = mainWaveWidth
                color = waveColor.withAlphaComponent(1.0)
            }else{
                waveLine.lineWidth = decorativeWavesWidth
                color = waveColor.withAlphaComponent(1.0 * multiplier)
            }
            
            waveLine.strokeColor = color?.cgColor
            layer.addSublayer(waveLine)
            waves.append(waveLine)
            
        }
        
    }
    
    @objc func incokeWaveCallBack() -> Void {
        waveLevelCallBack!(self)
    }
    
    func updateMeters() -> Void {
        UIGraphicsBeginImageContext(frame.size)
        
        for i in 0..<numberOfWaves {
            let waveLinePath = UIBezierPath()
            let progress: CGFloat = 1.0 - CGFloat(integerLiteral: i) / CGFloat(integerLiteral: numberOfWaves)
            let normedAmplitude = (1.5 * progress - 0.5) * amplitude
            
            var x: CGFloat = 0
            while(x < (waveWidth + density)){
                let scaling: CGFloat = -pow(x / waveMid - 1.0, 2.0) + 1.0
                let y: CGFloat = scaling * maxAmplitude * normedAmplitude * sin(2.0 * CGFloat.pi * (x / waveWidth) * frequency + phase) + (waveHeight * 0.5)
                if 0 == x{
                    waveLinePath.move(to: CGPoint(x: x, y: y))
                }
                else{
                    waveLinePath.addLine(to: CGPoint(x: x, y: y))
                }
                
                
                x += density
            }
            let waveLine: CAShapeLayer = waves[i]
            waveLine.path = waveLinePath.cgPath
        }
        
        UIGraphicsEndImageContext()
    }

}
