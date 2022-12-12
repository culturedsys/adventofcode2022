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


primitive Start
primitive Finish
primitive Other

type NodeType is (Start | Finish | Other)

class Node
  let _type: NodeType
  let _location: Point
  let _height: U8
  var _distance: U32

  new create(location': Point, height': U8) =>
    _type = Other
    _location = location'
    _height = height'
    _distance = U32.max_value()

  new start(location': Point) =>
    _type = Start
    _location = location'
    _height = 0
    _distance = 0

  new finish(location': Point) =>
    _type = Finish
    _location = location'
    _height = 'z' - 'a'
    _distance = U32.max_value()

  fun box is_start(): Bool =>
    _type is Start

  fun box is_finish(): Bool =>
    _type is Finish

  fun ref set_distance(distance': U32) =>
    _distance = distance'

  fun height(): U8 =>
    _height

  fun distance(): U32 => 
    _distance

  fun location(): Point =>
    _location

  fun neighbours(): Iterator[Point] =>
    [
      Point(_location.x - 1, _location.y)
      Point(_location.x + 1, _location.y)
      Point(_location.x, _location.y - 1)
      Point(_location.x, _location.y + 1)
    ].values()

class Nodes
  let _map: Map[Point, Node]
  let _unvisited: Unvisited
  let _start: Node
  let _finish: Node

  new parse(lines: Iterator[String])? =>
    _unvisited = Unvisited
    _map = Map[Point, Node]
    var start: (Node | None) = None
    var finish: (Node | None) = None
    var y: USize = 0
    for line in lines do
      var x: USize = 0
      for cell in line.values() do
        let node = match cell
        | 'S' => Node.start(Point(x, y))
        | 'E' => Node.finish(Point(x, y))
        else Node(Point(x, y), cell - 'a')
        end
        _map(Point(x, y)) = node
        _unvisited.add(node)
        if node.is_start() then start = node end
        if node.is_finish() then finish = node end
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

  fun ref find_shortest(): U32? =>
    _find_distances(true)?
    _finish.distance()

  fun ref _find_distances(ascending: Bool)? =>
    var current = _unvisited.pop()?
    while true do
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
        let via_current = current.distance() + 1
        if neighbour.distance() > via_current then
          neighbour.set_distance(via_current)
          _unvisited.update(neighbour)  
        end
      end
      try
        current = _unvisited.pop()?
      else
        break
      end
    end

    fun ref find_shortest_of_many(): U32? =>
      _start.set_distance(U32.max_value())
      _finish.set_distance(0)
      _find_distances(false)?
      var min = U32.max_value()
      for node in _map.values() do
        if (node.height() == 0) and (node.distance() < min) then
          min = node.distance()
        end
      end

      min


class Unvisited
  let _nodes: List[Node]

  new create() =>
    _nodes = List[Node]

  fun size(): USize =>
    _nodes.size()

  fun ref add(node: Node) =>
    _nodes.push(node)

  fun ref pop(): Node? =>
    let i = _nodes.nodes() 
    var min = i.next()?

    for n in i do
      if n()?.distance() < min()?.distance() then
        min = n  
      end
    end

    let ret = min()?
    min.remove()
    ret

  fun ref update(node: Node) =>
    // No-op; would do something if we were using an actual priority queue
    None

