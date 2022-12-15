use "collections"
use "debug"
use "itertools"


class val Point is (Equatable[Point] & Hashable & Stringable)
  let x: U32
  let y: U32

  new val create(x': U32, y': U32) =>
    x = x'
    y = y'

  fun box eq(other: Point): Bool =>
    (x == other.x) and (y == other.y)

  fun box hash(): USize =>
    x.hash() xor y.hash()

  fun box string(): String iso^ =>
    "Point(" + x.string() + ", " + y.string() + ")"


class Cave
  let filled: Set[Point]

  new from_lines(lines: Iterator[Array[Point]]) =>
    filled = Set[Point]
    for line in lines do
      let point_iter = line.values()
      var finish = try point_iter.next()? else continue end
      while true do
        let start = finish
        finish = try point_iter.next()? else break end
        for y in Range[U32](start.y.min(finish.y), start.y.max(finish.y) + 1) do
          for x in Range[U32](start.x.min(finish.x), start.x.max(finish.x) + 1) do
            filled.set(Point(x, y))
          end        
        end
      end
    end

  fun ref fill_to_abyss(start: Point): U32 =>
    let max = Iter[Point](filled.values())
        .map[U32]({ (p: Point) => p.y })
        .fold[U32](0, { (acc: U32, n: U32) => acc.max(n) })
    
    let filler = Filler(filled, start)
    while filler.current.y < max do
      filler.step()
    end

    filler.count

  fun ref fill_to_floor(start: Point): U32 =>
    let floor = 2 + Iter[Point](filled.values())
        .map[U32]({ (p: Point) => p.y })
        .fold[U32](0, { (acc: U32, n: U32) => acc.max(n) })
    
    let filler = Filler(filled, start, floor)
    while not filler.filled.contains(start) do
      filler.step()
    end

    filler.count


class Filler
  let filled: Set[Point]
  let floor: (U32 | None)
  let prev: Array[Point]
  var current: Point
  var count: U32

  new create(filled': Set[Point], start: Point, floor': (U32 | None) = None) =>
    filled = filled'
    prev = [start]
    current = start
    count = 0
    floor = floor'

  fun ref step() =>
    if empty(Point(current.x, current.y + 1)) then
      prev.push(current = Point(current.x, current.y + 1))
    elseif empty(Point(current.x - 1, current.y + 1)) then
      prev.push(current = Point(current.x - 1, current.y + 1))
    elseif empty(Point(current.x + 1, current.y + 1)) then
      prev.push(current = Point(current.x + 1, current.y + 1))
    else
      filled.set(current)
      count = count + 1
      current = try prev.pop()? else return end
    end    

  fun empty(target: Point): Bool =>
    let at_floor = match floor
    | let f: U32 => target.y >= f
    else false 
    end

    not (at_floor or filled.contains(target))


primitive Caves
  fun parse(lines: Iterator[String]): Array[Array[Point]]? =>
    let specs = Array[Array[Point]]
    for line in lines do
      let spec = Array[Point]
      for point in line.split_by(" -> ").values() do
        let parts = point.split(",")
        spec.push(Point(parts(0)?.u32()?, parts(1)?.u32()?))
      end
      specs.push(spec)
    end

    specs