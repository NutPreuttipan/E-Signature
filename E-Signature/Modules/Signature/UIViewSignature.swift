//
//  UIViewSignature.swift
//  E-Signature
//
//  Created by NUTiOS on 4/2/2564 BE.
//

import UIKit

protocol UIViewSignatureProtocol: class {
    func didFinishSign()
}

struct Line {
    let strokeWidth:Float
    let color: UIColor
    var points: [CGPoint]
}

class UIViewSignature: UIView {

    weak var delegate: UIViewSignatureProtocol?
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float = 1
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    fileprivate var lines = [Line]()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            
            for (i,p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard var lastLine = lines.popLast() else { return }
        lastLine.points.append(point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didFinishSign()
    }
}

