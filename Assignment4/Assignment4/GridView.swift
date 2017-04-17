//
//  GridView.swift
//  Assignment3
//
//  Created by Mike Haw on 3/15/17.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//

import UIKit

@IBDesignable class GridView: UIView {

    @IBInspectable var size : Int = 20
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var emptyColor : UIColor = UIColor.white
    @IBInspectable var bornColor : UIColor = UIColor.green
    @IBInspectable var diedColor : UIColor = UIColor.white
    @IBInspectable var gridColor : UIColor = UIColor.black
    @IBInspectable var gridwidth : CGFloat = 2.0
    
    lazy var grid : Grid  = Grid(self.size, self.size)

    override func draw(_ rect: CGRect) {
        let rect_size = CGSize(
            width: rect.size.width / CGFloat(size),
            height: rect.size.height / CGFloat(size)
        )
        
        let base = rect.origin
        
        (0 ..< size).forEach { i in
            (0 ..< size).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * rect_size.width),
                    y: base.y + (CGFloat(j) * rect_size.height)
                )
                let subRect = CGRect(origin: origin, size: rect_size)
                
                let cellState = StandardEngine.grid[Position(i,j)]
                
                switch cellState {
                    case .alive: livingColor.setFill()
                    case .empty: emptyColor.setFill()
                    case .born: bornColor.setFill()
                    case .died: diedColor.setFill()
                }
                
                let path = UIBezierPath(ovalIn: subRect)
                path.fill()
            }
        }
        
        (0 ..< (size + 1)).forEach { i in
            
            drawLine(
                start: CGPoint(x: (base.x + (CGFloat(i) * rect_size.width)), y: base.y),
                end: CGPoint(x: (base.x + (CGFloat(i) * rect_size.width)), y: (base.y + rect.size.height))
            )
        
            drawLine(
                start: CGPoint(x: base.x, y: (base.y + (CGFloat(i) * rect_size.height))),
                end: CGPoint(x: (base.x + rect.size.width), y: (base.y + (CGFloat(i) * rect_size.height)))
            )
        }
    }
    
    func drawLine(start: CGPoint, end: CGPoint) {
        let path = UIBezierPath()
        path.lineWidth = CGFloat(gridwidth)
        path.move(to: start)
        path.addLine(to: end)
        gridColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = process(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchedPosition = nil
    }
    
    typealias Position = (row: Int, col: Int)
    var lastTouchedPosition: Position?
    
    func process(touches: Set<UITouch>) -> Position? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        let r = pos.row
        let c = pos.col
        
        StandardEngine.grid[row: r, col: c] = grid[row: r, col: c].toggle(value: grid[row: r, col: c])
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> Position {
        
        let row = touch.location(in:self).x / (frame.size.width / CGFloat(size))
        let col = touch.location(in:self).y / (frame.size.height / CGFloat(size))

        let position = (row: Int(row), col: Int(col))
        return position
    }
    
}
