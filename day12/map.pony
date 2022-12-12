use "collections"
use "format"


class val Point is (Hashable & Equatable[Point] & Stringable)
  let x: USize
  let y: USize

  new val create(x': USize, y': USize) =>
    x = x'
    y = y'

  fun box hash(): USize =>
    x.hash() xor y.hash()

  fun eq(other: Point): Bool =>
    (x == other.x) and (y == other.y)

  fun box string(): String iso^ =>
    "(" + x.string() + ", " + y.string() + ")"


class Node
  let _location: Point
  let _height: U8
  var _distance: U32
  var _seen: Bool

  new create(location': Point, height': U8) =>
    _location = location'
    _height = height'
    _distance = 0
    _seen = false

  fun ref set_distance(distance': U32) =>
    _distance = distance'

  fun height(): U8 =>
    _height

  fun distance(): U32 => 
    _distance

  fun location(): Point =>
    _location

  fun ref set_seen() =>
    _seen = true

  fun seen(): Bool =>
    _seen

  fun neighbours(): Iterator[Point] =>
    [
      Point(_location.x - 1, _location.y)
      Point(_location.x + 1, _location.y)
      Point(_location.x, _location.y - 1)
      Point(_location.x, _location.y + 1)
    ].values()

class Nodes
  let _map: Map[Point, Node]
  let _start: Node
  let _finish: Node

  new parse(lines: Iterator[String])? =>
    _map = Map[Point, Node]
    var start: (Node | None) = None
    var finish: (Node | None) = None
    var y: USize = 0
    for line in lines do
      var x: USize = 0
      for cell in line.values() do
        let node = match cell
        | 'S' => 
          let s = Node(Point(x, y), 0)
          start = s
          s
        | 'E' => 
          let f = Node(Point(x, y), 'z' - 'a')
          finish = f
          f
        else Node(Point(x, y), cell - 'a')
        end

        _map(Point(x, y)) = node
        x = x + 1
      end
      y = y + 1
    end

    match (start, finish)
    | (let s: Node, let f: Node) => 
      _start = s
      _finish = f
    else
      error
    end

  fun ref find_shortest_to_finish(): U32? =>
    _find_distances(true, _start, { (n) => n is _finish })?


  fun ref find_shortest_to_lowest(): U32? =>
    _find_distances(false, _finish, { (n) => n.height() == 0 })?

  fun ref _find_distances(ascending: Bool, start: Node, condition: Condition): U32? =>
    var current = start
    let queue = List[Node]
    while true do
      if condition(current) then
        return current.distance()  
      end
      for neighbour_coord in current.neighbours() do
        let neighbour = try
            _map(neighbour_coord)?
          else
            continue
          end
        if (ascending and (neighbour.height() > (current.height() + 1))) or 
          ((not ascending) and (neighbour.height() < (current.height() - 1))) then
          continue  
        end
        neighbour.set_distance(current.distance() + 1)
        if not neighbour.seen() then
          neighbour.set_seen()
          queue.push(neighbour)
        end
      end
      try
        current = queue.shift()?
      else
        break
      end
    end
    
    error


interface Condition
  fun apply(node: Node): Bool
 