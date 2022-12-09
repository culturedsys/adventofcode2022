use "collections"

class val Point is(Equatable[Point] & Stringable & Hashable)
  let x: I32
  let y: I32

  new val create(x': I32, y': I32) =>
    x = x'
    y = y'

  fun sub(other: Point): Vector =>
    Vector(x - other.x, y - other.y)

  fun add(other: Vector): Point =>
    Point(x + other.dx, y + other.dy)
    
  fun eq(other: Point): Bool =>
    (x == other.x) and (y == other.y)

  fun box string(): String iso^ =>
    "(" + x.string() + ", " + y.string() + ")"

  fun box hash(): USize =>
    x.hash() xor y.hash()


class val Vector
  let dx: I32
  let dy: I32

  new val create(dx': I32, dy': I32) =>
    dx = dx'
    dy = dy'

  fun unit(): Vector =>
    Vector(if dx > 0 then 1 elseif dx < 0 then -1 else 0 end,
      if dy > 0 then 1 elseif dy < 0 then - 1 else 0 end) 

class Rope
  let _knots: Array[Point]

  new create(knots: Array[Point]) =>
    _knots = knots

  fun head(): Point => try _knots(0)? else Point(0, 0) end
  fun tail(): Point => try _knots(_knots.size() - 1)? else Point(0, 0) end 

  fun ref move(movement: Vector) =>
    try
      _knots(0)? = _knots(0)? + movement
      for i in Range(1, _knots.size()) do
        let delta = _knots(i - 1)? - _knots(i)?
        if (delta.dx.abs() > 1) or (delta.dy.abs() > 1) then
          _knots(i)? = _knots(i)? + delta.unit()
        end
      end
    end

  class Trail
    let _movements: Array[(Vector, U32)]
    let _tails: Set[Point]
    let _rope: Rope

    new create(rope: Rope, lines: Iterator[String])? =>
      _rope = rope
      _tails = Set[Point]()
      _movements = []
      for line in lines do
        let parts = line.split()
        let count = parts(1)?.u32()?
        let dir = match parts(0)?
        | "U" => Vector(0, -1)
        | "R" => Vector(1, 0)
        | "D" => Vector(0, 1)
        | "L" => Vector(-1, 0)
        else error
        end
        _movements.push((dir, count))
      end

    fun ref follow(): USize =>
      for movement in _movements.values() do
        for i in Range[U32](0, movement._2) do
          _rope.move(movement._1)
          _tails.set(_rope.tail())
        end
      end

      _tails.size()