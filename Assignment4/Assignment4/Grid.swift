//
//  Grid.swift
//
//  Created by Joseph (Mike) Haw on 4/25/2017.
//  Icon(s) courtesy of Freepik from www.flaticon.com
//
import Foundation

public typealias GridPosition = (row: Int, col: Int)
public typealias GridSize = (rows: Int, cols: Int)

fileprivate func norm(_ val: Int, to size: Int) -> Int { return ((val % size) + size) % size }

public enum CellState {
    case alive, empty, born, died
    
    public var isAlive: Bool {
        switch self {
        case .alive, .born: return true
        default: return false
        }
    }
}

public protocol GridProtocol {
    init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState)
    var description: String { get }
    var size: GridSize { get }
    subscript (row: Int, col: Int) -> CellState { get set }
    func next() -> Self 
}

public let lazyPositions = { (size: GridSize) in
    return (0 ..< size.rows)
        .lazy
        .map { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
        .flatMap { $0 }
        .map { GridPosition($0) }
}


let offsets: [GridPosition] = [
    (row: -1, col:  -1), (row: -1, col:  0), (row: -1, col:  1),
    (row:  0, col:  -1),                     (row:  0, col:  1),
    (row:  1, col:  -1), (row:  1, col:  0), (row:  1, col:  1)
]

extension GridProtocol {
    public var description: String {
        return lazyPositions(self.size)
            .map { (self[$0.row, $0.col].isAlive ? "*" : " ") + ($0.col == self.size.cols - 1 ? "\n" : "") }
            .joined()
    }
    
    private func neighborStates(of pos: GridPosition) -> [CellState] {
        return offsets.map { self[pos.row + $0.row, pos.col + $0.col] }
    }
    
    private func nextState(of pos: GridPosition) -> CellState {
        let iAmAlive = self[pos.row, pos.col].isAlive
        let numLivingNeighbors = neighborStates(of: pos).filter({ $0.isAlive }).count
        switch numLivingNeighbors {
        case 2 where iAmAlive,
             3: return iAmAlive ? .alive : .born
        default: return iAmAlive ? .died  : .empty
        }
    }
    
    public func next() -> Self {
        var nextGrid = Self(size.rows, size.cols) { _, _ in .empty }
        lazyPositions(self.size).forEach { nextGrid[$0.row, $0.col] = self.nextState(of: $0) }
        return nextGrid
    }
}

public struct Grid: GridProtocol, GridViewDataSource {
    private var _cells: [[CellState]]
    public let size: GridSize

    public subscript (row: Int, col: Int) -> CellState {
        get { return _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] }
        set { _cells[norm(row, to: size.rows)][norm(col, to: size.cols)] = newValue }
    }
    
    public init(_ rows: Int, _ cols: Int, cellInitializer: (GridPosition) -> CellState = { _, _ in .empty }) {
        _cells = [[CellState]](repeatElement( [CellState](repeatElement(.empty, count: rows)), count: cols))
        size = GridSize(rows, cols)
        lazyPositions(self.size).forEach { self[$0.row, $0.col] = cellInitializer($0) }
    }
}

extension Grid: Sequence {
    fileprivate var living: [GridPosition] {
        return lazyPositions(self.size).filter { return  self[$0.row, $0.col].isAlive   }
    }
    
    public struct GridIterator: IteratorProtocol {
        private class GridHistory: Equatable {
            let positions: [GridPosition]
            let previous:  GridHistory?
            
            static func == (lhs: GridHistory, rhs: GridHistory) -> Bool {
                return lhs.positions.elementsEqual(rhs.positions, by: ==)
            }
            
            init(_ positions: [GridPosition], _ previous: GridHistory? = nil) {
                self.positions = positions
                self.previous = previous
            }
            
            var hasCycle: Bool {
                var prev = previous
                while prev != nil {
                    if self == prev { return true }
                    prev = prev!.previous
                }
                return false
            }
        }
        
        private var grid: GridProtocol
        private var history: GridHistory!
        
        init(grid: Grid) {
            self.grid = grid
            self.history = GridHistory(grid.living)
        }
        
        public mutating func next() -> GridProtocol? {
            if history.hasCycle { return nil }
            let newGrid:Grid = grid.next() as! Grid
            history = GridHistory(newGrid.living, history)
            grid = newGrid
            let nc = NotificationCenter.default
            let name = Notification.Name(rawValue: "EngineUpdate")
            let n = Notification(name: name,
                                 object: nil,
                                 userInfo: ["engine" : self])
            nc.post(n)
            return grid
        }
    }
    
    public func makeIterator() -> GridIterator { return GridIterator(grid: self) }
}

public extension Grid {
    public static func gliderInitializer(pos: GridPosition) -> CellState {
        switch pos {
        case (0, 1), (1, 2), (2, 0), (2, 1), (2, 2): return .alive
        default: return .empty
        }
    }
    
}

public protocol EngineDelegate {
    func engineDidUpdate(withGrid: GridProtocol)
}

public protocol EngineProtocol {
    var grid: GridProtocol { get set }
    
    var delegate: EngineDelegate? { get set }
    
    var refreshRate: Double { get set }
    
    var refreshTimer: Timer? { get set }
    
    var updateClosure: ((Grid) -> Void)? { get set }
    
    var rows: Int { get set }
    
    var cols: Int { get set }
    
    init(_ rows: Int, _ cols: Int)
    
    func step() -> GridProtocol
    
}

public class StandardEngine: EngineProtocol {
 
   static let engine : StandardEngine = StandardEngine(10, 10)
    
    public var grid: GridProtocol {
        didSet {
            guard (rows != grid.size.rows) else { return }
            rows = grid.size.rows
            cols = grid.size.cols
        }
    }
    
    public var delegate: EngineDelegate?
    
    public var updateClosure: ((Grid) -> Void)?
    
    public var refreshTimer: Timer?
    
    public var refreshRate: TimeInterval = 0.0 {
        didSet {
            if refreshRate > 0.0 {
                refreshTimer = Timer.scheduledTimer(
                    withTimeInterval: refreshRate,
                    repeats: true
                ) { (t: Timer) in
                    _ = self.step()
                }
            }
            else {
                refreshTimer?.invalidate()
                refreshTimer = nil
        }
    }
    }
    
    public var rows: Int
    
    public var cols: Int
    
    public var size : Int {
        didSet {
            self.rows = size
            self.cols = size
            self.grid = Grid(rows, cols)
            delegate?.engineDidUpdate(withGrid: grid)
            self.notify()
            
        }
    }
    
    public required init(_ rows: Int, _ cols: Int) {
        self.size = 10
        self.rows = rows
        self.cols = cols
        self.grid = Grid(rows, cols)
        delegate?.engineDidUpdate(withGrid: self.grid)
        self.notify()

    }

    public func step() -> GridProtocol {
        let newGrid = grid.next()
        grid = newGrid
        updateClosure?(self.grid as! Grid)
        delegate?.engineDidUpdate(withGrid: grid)
        self.notify()
        return grid
        
    }
    
    public func notify() {
        let nc = NotificationCenter.default
        let name = Notification.Name(rawValue: "EngineUpdate")
        let n = Notification(name: name,
                             object: nil,
                             userInfo: ["engine" : self])
        nc.post(n)
    }
}
