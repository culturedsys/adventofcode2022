use "collections"
use "debug"
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

  new parse(lines: Iterator[String]) =>
    _unvisited = Unvisited
    _map = Map[Point, Node]
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
        x = x + 1
      end
      y = y + 1
    end

  fun ref find_shortest(): U32? =>
    var current = _unvisited.pop()?
    while true do
      // Debug.err("Current: " + current.location().string())
      for neighbour_coord in current.neighbours() do
        let neighbour = try
            _map(neighbour_coord)?
          else
            continue
          end
        // Debug.err(neighbour.location().string() + ": " + current.height().string() + " ^ " + neighbour.height().string())
        if neighbour.height() > (current.height() + 1) then
          continue  
        end
        let via_current = current.distance() + 1
        if neighbour.distance() > via_current then
          // Debug.err(current.location().string() + " -> " + neighbour.location().string() + " changed " + neighbour.distance().string() + " to " + via_current.string())
          neighbour.set_distance(via_current)
          _unvisited.update(neighbour)  
        end
      end
      current = _unvisited.pop()?
      if current.is_finish() then
        // for y in Range(0, 5) do
        //   var line = ""
        //   for x in Range(0, 8) do
        //     line = line + Format.int[U32](_map(Point(x, y))?.distance() where width=11)
        //   end
        //   Debug.err(line)
        // end
        return current.distance()
      end
    end

    error


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

