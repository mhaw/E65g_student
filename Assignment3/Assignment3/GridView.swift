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
    @IBInspectable var livingColor = UIColor.green
    @IBInspectable var emptyColor = UIColor.white
    @IBInspectable var bornColor = UIColor.blue
    @IBInspectable var diedColor = UIColor.black
    @IBInspectable var gridColor = UIColor.black
    @IBInspectable var gridwidth = CGFloat(2.0)
    
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
                
                let cellState = grid[Position(i,j)]
                
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
            // vertical line
            drawLine(
                start: CGPoint(x: (base.x + (CGFloat(i) * rect_size.width)), y: base.y),
                end: CGPoint(x: (base.x + (CGFloat(i) * rect_size.width)), y: (base.y + rect.size.height))
            )
            
            //horizantal line
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
        return
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        return
    }
    
}
