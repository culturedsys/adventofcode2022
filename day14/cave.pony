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

  fun ref fill(start: Point): U32 =>
    let max = Iter[Point](filled.values())
        .map[U32]({ (p: Point) => p.y })
        .fold[U32](0, { (acc: U32, n: U32) => acc.max(n) })
    Debug.err("max = " + max.string())
    let prev = [start]
    var current = start
    var count: U32 = 0

    while current.y < max do
      // Debug.err(current)
      if not filled.contains(Point(current.x, current.y + 1)) then
        prev.push(current = Point(current.x, current.y + 1))
        // Debug.err("Empty: " + current.string())
      elseif not filled.contains(Point(current.x - 1, current.y + 1)) then
        prev.push(current = Point(current.x - 1, current.y + 1))
        // Debug.err("Empty: " + current.string())
      elseif not filled.contains(Point(current.x + 1, current.y + 1)) then
        prev.push(current = Point(current.x + 1, current.y + 1))
        // Debug.err("Empty: " + current.string())
      else
        // Debug.err("Settled: " + current.string())
        filled.set(current)
        count = count + 1
        while filled.contains(current) do
          current = try prev.pop()? else start end
        end
      end    
    end

    count