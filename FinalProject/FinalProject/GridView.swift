//
//  GridView.swift
//  Assignment4
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Copyright © 2017 Harvard Division of Continuing Education. All rights reserved.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//

import UIKit

public protocol GridViewDataSource {
    subscript (row: Int, col: Int) -> CellState { get set }
}

@IBDesignable class GridView: UIView {
    
    
    @IBInspectable var gridSize = Int(StandardEngine.engine.size)
    @IBInspectable var livingColor : UIColor = UIColor.green
    @IBInspectable var emptyColor : UIColor = UIColor.white
    @IBInspectable var bornColor : UIColor = UIColor.green
    @IBInspectable var diedColor : UIColor = UIColor.white
    @IBInspectable var gridColor : UIColor = UIColor.black
    @IBInspectable var gridwidth : CGFloat = 2.0
    
    var gridDataSource: GridViewDataSource?

    override func draw(_ rect: CGRect) {
        
        let rect_size = CGSize(
            width: rect.size.width / CGFloat(gridSize),
            height: rect.size.height / CGFloat(gridSize)
        )
        
        let base = rect.origin
        
        (0 ..< gridSize).forEach { i in
            (0 ..< gridSize).forEach { j in
                let origin = CGPoint(
                    x: base.x + (CGFloat(i) * rect_size.width),
                    y: base.y + (CGFloat(j) * rect_size.height)
                )
                let subRect = CGRect(origin: origin, size: rect_size)
                
                let cellState = StandardEngine.engine.grid[i,j]
                
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
        
        (0 ..< (gridSize + 1)).forEach { i in
            
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
    
    typealias GridPosition = (row: Int, col: Int)
    var lastTouchedPosition: GridPosition?
    
    func process(touches: Set<UITouch>) -> GridPosition? {
        guard touches.count == 1 else { return nil }
        let pos = convert(touch: touches.first!)
        guard lastTouchedPosition?.row != pos.row
            || lastTouchedPosition?.col != pos.col
            else { return pos }
        
        let r = pos.row
        let c = pos.col
        
        StandardEngine.engine.grid[r, c] = StandardEngine.engine.grid[r, c].isAlive ? .empty : .alive
        setNeedsDisplay()
        return pos
    }
    
    func convert(touch: UITouch) -> GridPosition {
        
        let row = touch.location(in:self).x / (frame.size.width / CGFloat(gridSize))
        let col = touch.location(in:self).y / (frame.size.height / CGFloat(gridSize))
        
        let position = (row: Int(row), col: Int(col))
        return position
    }
    
    public func countAlive() -> [[Int]] {
        var alives: [[Int]] = []
        
        let this_engine = StandardEngine.engine
        
        (0 ..< this_engine.grid.size.rows).forEach { row in
            (0 ..< this_engine.grid.size.cols).forEach { col in
                let cell = this_engine.grid[row,col]
                if(cell.isAlive) {
                    alives.append([row,col])
                }
            }
        }
        return alives
    }
    
    

    
}
