//
//  main.swift
//  adventofcode13
//
//  Created by Cruse, Si on 12/13/18.
//  Copyright © 2018 Cruse, Si. All rights reserved.
//

import Foundation

//    --- Day 13: Mine Cart Madness ---
//    A crop of this size requires significant logistics to transport produce, soil, fertilizer, and so on. The Elves are very busy pushing things around in carts on some kind of rudimentary system of tracks they've come up with.
//
//    Seeing as how cart-and-track systems don't appear in recorded history for another 1000 years, the Elves seem to be making this up as they go along. They haven't even figured out how to avoid collisions yet.
//
//    You map out the tracks (your puzzle input) and see where you can help.
//
//    Tracks consist of straight paths (| and -), curves (/ and \), and intersections (+). Curves connect exactly two perpendicular pieces of track; for example, this is a closed loop:
//
//        /----\
//        |    |
//        |    |
//        \----/
//        Intersections occur when two perpendicular paths cross. At an intersection, a cart is capable of turning left, turning right, or continuing straight. Here are two loops connected by two intersections:
//        
//        /-----\
//        |     |
//        |  /--+--\
//        |  |  |  |
//        \--+--/  |
//        |     |
//        \-----/
//        Several carts are also on the tracks. Carts always face either up (^), down (v), left (<), or right (>). (On your initial map, the track under each cart is a straight path matching the direction the cart is facing.)
//
//        Each time a cart has the option to turn (by arriving at any intersection), it turns left the first time, goes straight the second time, turns right the third time, and then repeats those directions starting again with left the fourth time, straight the fifth time, and so on. This process is independent of the particular intersection at which the cart has arrived - that is, the cart has no per-intersection memory.
//        
//        Carts all move at the same speed; they take turns moving a single step at a time. They do this based on their current location: carts on the top row move first (acting from left to right), then carts on the second row move (again from left to right), then carts on the third row, and so on. Once each cart has moved one step, the process repeats; each of these loops is called a tick.
//
//    For example, suppose there are two carts on a straight track:
//
//    |  |  |  |  |
//    v  |  |  |  |
//    |  v  v  |  |
//    |  |  |  v  X
//    |  |  ^  ^  |
//    ^  ^  |  |  |
//    |  |  |  |  |
//    First, the top cart moves. It is facing down (v), so it moves down one square. Second, the bottom cart moves. It is facing up (^), so it moves up one square. Because all carts have moved, the first tick ends. Then, the process repeats, starting with the first cart. The first cart moves down, then the second cart moves up - right into the first cart, colliding with it! (The location of the crash is marked with an X.) This ends the second and last tick.
//
//    Here is a longer example:
//
//    /->-\
//    |   |  /----\
//    | /-+--+-\  |
//    | | |  | v  |
//    \-+-/  \-+--/
//    \------/
//
//    /-->\
//    |   |  /----\
//    | /-+--+-\  |
//    | | |  | |  |
//    \-+-/  \->--/
//    \------/
//
//    /---v
//    |   |  /----\
//    | /-+--+-\  |
//    | | |  | |  |
//    \-+-/  \-+>-/
//    \------/
//
//    /---\
//    |   v  /----\
//    | /-+--+-\  |
//    | | |  | |  |
//    \-+-/  \-+->/
//    \------/
//
//    /---\
//    |   |  /----\
//    | /->--+-\  |
//    | | |  | |  |
//    \-+-/  \-+--^
//    \------/
//
//    /---\
//    |   |  /----\
//    | /-+>-+-\  |
//    | | |  | |  ^
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /----\
//    | /-+->+-\  ^
//    | | |  | |  |
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /----<
//    | /-+-->-\  |
//    | | |  | |  |
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /---<\
//    | /-+--+>\  |
//    | | |  | |  |
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /--<-\
//    | /-+--+-v  |
//    | | |  | |  |
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /-<--\
//    | /-+--+-\  |
//    | | |  | v  |
//    \-+-/  \-+--/
//    \------/
//
//    /---\
//    |   |  /<---\
//    | /-+--+-\  |
//    | | |  | |  |
//    \-+-/  \-<--/
//    \------/
//
//    /---\
//    |   |  v----\
//    | /-+--+-\  |
//    | | |  | |  |
//    \-+-/  \<+--/
//    \------/
//
//    /---\
//    |   |  /----\
//    | /-+--v-\  |
//    | | |  | |  |
//    \-+-/  ^-+--/
//    \------/
//
//    /---\
//    |   |  /----\
//    | /-+--+-\  |
//    | | |  X |  |
//    \-+-/  \-+--/
//    \------/
//    After following their respective paths for a while, the carts eventually crash. To help prevent crashes, you'd like to know the location of the first crash. Locations are given in X,Y coordinates, where the furthest left column is X=0 and the furthest top row is Y=0:
//
//    111
//    0123456789012
//    0/---\
//    1|   |  /----\
//    2| /-+--+-\  |
//    3| | |  X |  |
//    4\-+-/  \-+--/
//    5  \------/
//    In this example, the location of the first crash is 7,3.

// Utility storage class
struct Matrix<T> {
    let rows: Int, columns: Int
    var grid: [T]
    init(rows: Int, columns: Int,defaultValue: T) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: defaultValue, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> T {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    var row_range: ClosedRange<Int> { return 0...self.rows - 1 }
    var column_range: ClosedRange<Int> { return 0...self.columns - 1 }
}

class Truck: CustomDebugStringConvertible {
    enum State {
        case rolling
        case crashed
    }

    // Valid truck turns + transitions
    enum Turn {
        case left
        case straight
        case right
        
        var nextTurn: Turn {
            switch self {
            case .left:     return .straight
            case .straight: return .right
            case .right:    return .left
            }
        }
    }
    
    // Truck orientation & movement + transitions
    enum TruckOrientation: CustomDebugStringConvertible {
        case up
        case down
        case left
        case right
        
        static let symbols = "^v<>"
        
        init?(symbol: Character) {
            switch symbol {
            case "^": self = .up
            case "v": self = .down
            case "<": self = .left
            case ">": self = .right
            default:
                print("Error: unexpected truck character")
                return nil
            }
        }
        
        var char: Character {
            switch self {
            case .up:       return "^"
            case .down:     return "v"
            case .left:     return "<"
            case .right:    return ">"
            }
        }    
        
        var vector: (x: Int, y: Int) {
            switch self {
            case .up:       return (0, -1)
            case .down:     return (0, 1)
            case .left:     return (-1, 0)
            case .right:    return (1, 0)
            }
        }
        
        func turn(direction: Turn) -> TruckOrientation {
            switch direction {
            case .left:
                switch self {
                case .up:       return .left
                case .down:     return .right
                case .left:     return .down
                case .right:    return .up
                }
            case .right:
                switch self {
                case .up:       return .right
                case .down:     return .left
                case .left:     return .up
                case .right:    return .down
                }            
            case .straight:     return self
            }
        }
        
        var debugDescription: String {
            return String(char)
        }    
    }
    
    private var _orientation: TruckOrientation
    private var _locus: (x: Int, y: Int)
    private var _nextturn: Turn = .left
    private var _state: State = .rolling
    
    init?(locus: (x:Int, y: Int), symbol: Character) {
        self._locus = locus
        if let orientation = TruckOrientation(symbol: symbol) {
            self._orientation = orientation
        } else {
            return nil
        }
    }
    
    func orient(to: Track.Node) {
        (_orientation, _nextturn) = to.reorient(orientation: _orientation, nextturn: _nextturn)
    }
    
    func move() {
        if _state == .crashed { return }
        let vector = _orientation.vector
        _locus = (_locus.x + vector.x, _locus.y + vector.y)
    }
    
    func crash() {
        _state = .crashed
    }
    
    var locus: (x: Int, y: Int) {
        get { return _locus }
    }

    var orientation: TruckOrientation {
        get { return _orientation }
    }
    
    var state: State {
        get { return _state }
    }
    
    var debugDescription: String {
        return _state == .rolling ? _orientation.debugDescription : "X"
    }    
}

class Track: CustomDebugStringConvertible {
    // Path to the problem input data
    static let inputpath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("input.txt")
    static let test1path = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("test1.txt")
    static let test2path = URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("test2.txt")

    enum StopClause {
        case firstcrash, lastcrash
    }
    
    // Track nodes
    enum Node: CustomDebugStringConvertible {
        case backslash
        case slash
        case vertical
        case horizontal
        case junction
        
        static let symbols = "\\/|-+"
        
        init?(symbol: Character) {
            switch symbol {
            case "\\": self = .backslash
            case "/": self = .slash
            case "|": self = .vertical
            case "-": self = .horizontal
            case "+": self = .junction
            default:
                print("Error: unexpected track character")
                return nil
            }
        }
        
        init(under: Truck) {
            switch under.orientation {
            case .up, .down: self = .vertical
            case .left, .right: self = .horizontal
            }
        } 
        
        func reorient(orientation: Truck.TruckOrientation, nextturn: Truck.Turn) -> (Truck.TruckOrientation, Truck.Turn) {
            switch self {
            case .backslash:
                switch orientation {
                case .up:    return (.left, nextturn)
                case .down:  return (.right, nextturn)
                case .left:  return (.up, nextturn)
                case .right: return (.down, nextturn)
                }
            case .slash:
                switch orientation {
                case .up:    return (.right, nextturn)
                case .down:  return (.left, nextturn)
                case .left:  return (.down, nextturn)
                case .right: return (.up, nextturn)
                }            
            case .vertical, .horizontal: return (orientation , nextturn)
            case .junction: return (orientation.turn(direction: nextturn) , nextturn.nextTurn)
            }
        }
        
        var char: Character {
            switch self {
            case .backslash:    return "\\"
            case .slash:        return "/"
            case .vertical:     return "|"
            case .horizontal:   return "-"
            case .junction:     return "+"
            }
        }
        
        var debugDescription: String {
            return String(char)
        }
    }   
    private var _matrix: Matrix<Node?>
    private var _trucks: [Truck] = []
    private let stopif: StopClause
    
    init(lines: [String], stopif: StopClause) {
        self.stopif = stopif
        let width = lines.max{$0.count < $1.count}!.count
        _matrix = Matrix<Node?>(rows: lines.count, columns: width, defaultValue: nil)
        hydrate(input: lines)
    }

    convenience init(contentsOf: URL, stopif: StopClause) {
        do {
            let data = try String(contentsOf: contentsOf)
            let strings = data.components(separatedBy: .newlines)
            self.init(lines: strings.filter({ $0.count > 0 }), stopif: stopif)
        } catch {
            print(error)
            self.init(lines: [], stopif: stopif)
        }
    }

    func tick() -> (x: Int, y: Int)? {
        // get a list of active trucks sorted from top-left, add an enumeration index to help with collision detection 
        let trucks = _trucks.filter{$0.state == .rolling}.sorted{ $0.locus.y != $1.locus.y ? $0.locus.y < $1.locus.y : $0.locus.x < $1.locus.x }.enumerated()
        for t in trucks {
            // Move the truck
            t.element.move()
            // respect the simulation goal, report the location of the last "rolling" truck
            if stopif == .lastcrash && trucks.filter({ $0.element.state == .rolling }).count <= 1 { return lasttruck?.locus }
            // Determine if any trucks have collided as a result of movement, use the enumeration index to avoid detecting collision with self!
            if !trucks.filter({ $0.element.state == .rolling && $0.element.locus == t.element.locus && $0.offset != t.offset }).isEmpty {
                // CRASH!!! The Elves immediately clean up the debris!
                cleardebris(locus: t.element.locus)
                // respect the simulation goal, report the location of the first crash
                if stopif == .firstcrash { return t.element.locus }
            } else if let node = _matrix[t.element.locus.y, t.element.locus.x] {
                // No collision occurred, reorient the truck as the map node dictates
                t.element.orient(to: node)
            } else {
                // Should never get here, if you do there is likely something wrong with the map file (Damn you XCode!)
                assertionFailure("Truck fell off the track :(")
            }
        }
        return nil
    }
    
    private func cleardebris(locus: (x:Int, y: Int)) {
        for t in _trucks.filter({$0.locus == locus}) {
            t.crash()
        }
    }
    
    private var lasttruck: Truck? {
        get {
            return _trucks.filter{$0.state == .rolling}.last
        }
    }
    
    // Load data
    private func hydrate(input: [String]) {
        for (row, line) in input.enumerated() {
            for (column, symbol) in line.enumerated() {
                if symbol == " " {
                    continue
                } else if Node.symbols.contains(symbol) {
                    _matrix[row, column] = Node(symbol: symbol)
                } else if Truck.TruckOrientation.symbols.contains(symbol) {
                    if let truck = Truck(locus: (x: column, y: row), symbol: symbol) {
                        _trucks.append(truck)
                        _matrix[row, column] = Node(under: truck)
                    }
                } else {
                    assertionFailure("Encountered unknown symbol in file")
                }
            }
        }
    }
    
    private func debugRow(row: Int) -> String {
        var line = ""
        for column in _matrix.column_range {
            if let truck = _trucks.reduce(nil, { symbol, t in t.locus == (x: column, y: row) ? t.debugDescription : symbol ?? nil}) {
                line += truck
            } else if let char = _matrix[row, column] {
                line += String(char.debugDescription)
            } else {
                line += " "
            }
        }
        return line + "\n"        
    }
    
    var debugDescription: String {
        var result = ""
        for row in _matrix.row_range {
            result += debugRow(row: row)
        }
        return result
    }
}

// Stage 1 - TEST
let tracktest1 = Track(contentsOf: Track.test1path, stopif: .firstcrash)
var testcrash: (x: Int, y: Int)? = nil
repeat {
    testcrash = tracktest1.tick()
} while testcrash == nil
print("The FIRST TEST answer is \(testcrash!)\n")


// Stage 1 - RUN
let track1 = Track(contentsOf: Track.inputpath, stopif: .firstcrash)
var crash: (x: Int, y: Int)? = nil
repeat {
    crash = track1.tick()
} while crash == nil
print("The FIRST CHALLENGE answer is \(crash!)\n")

//        --- Part Two ---
//    There isn't much you can do to prevent crashes in this ridiculous system. However, by predicting the crashes, the Elves know where to be in advance and instantly remove the two crashing carts the moment any crash occurs.
//
//    They can proceed like this for a while, but eventually, they're going to run out of carts. It could be useful to figure out where the last cart that hasn't crashed will end up.
//
//    For example:
//
//    />-<\  
//    |   |  
//    | /<+-\
//    | | | v
//    \>+</ |
//    |   ^
//    \<->/
//
//    /---\  
//    |   |  
//    | v-+-\
//    | | | |
//    \-+-/ |
//    |   |
//    ^---^
//
//    /---\  
//    |   |  
//    | /-+-\
//    | v | |
//    \-+-/ |
//    ^   ^
//    \---/
//
//    /---\  
//    |   |  
//    | /-+-\
//    | | | |
//    \-+-/ ^
//    |   |
//    \---/
//    After four very expensive crashes, a tick ends with only one cart remaining; its final location is 6,4.
//
//    What is the location of the last cart at the end of the first tick where it is the only cart left?
//

// Stage 2 - TEST
let tracktest2 = Track(contentsOf: Track.test2path, stopif: .lastcrash)
var lasttest: (x: Int, y: Int)? = nil
repeat {
    lasttest = tracktest2.tick()
} while lasttest == nil
print("The SECOND TEST answer is \(lasttest!)\n")


// Stage 2 - RUN
let track2 = Track(contentsOf: Track.inputpath, stopif: .lastcrash)
var last: (x: Int, y: Int)? = nil
repeat {
    last = track2.tick()
} while last == nil
print("The SECOND CHALLENGE answer is \(last!)\n")


