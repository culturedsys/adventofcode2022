use "collections"
use "debug"
use "../lib"

primitive Done

class val Mark
  let x: USize
  let y: USize

  new val create(x': USize, y': USize) =>
    x = x'
    y = y'


type Command is (Done | Mark)

interface Marker
  fun ref apply(c: Command)


primitive Trees
  fun visible_row(heights: Array[Array[U8] val] val, r: USize, range: Range[USize], marker: Marker) =>
    try
      let row = heights(r)?
      let start = range.next()?
      marker(Mark(start, r))
      var max = row(start)?
      for x in range do
        if row(x)? > max then
          marker(Mark(x, r))
          max = row(x)?
        end
      end

      marker(Done)
    end

  fun visible_col(heights: Array[Array[U8] val] val, col: USize, range: Range[USize], marker: Marker) =>
    try
      let start = range.next()?
      marker(Mark(col, start))
      var max = heights(start)?(col)?
      for y in range do
        if heights(y)?(col)? > max then
          marker(Mark(col, y))
          max = heights(y)?(col)?
        end
      end

      marker(Done)
    end

  fun scenic_score_dir(heights: Array[Array[U8] val] val, height: U8, range: Range[USize], 
      constant: USize, vertical: Bool): U32 =>
    var score: U32 = 0

    for i in range do
      try
        score = score + 1
        let current = if vertical then heights(i)?(constant)? else heights(constant)?(i)? end
        if current >= height then
          break
        end
      end
    end

    score

  fun scenic_score(heights: Array[Array[U8] val] val, x: USize, y: USize): U32 =>
    let height = try heights(y)?(x)? else 0 end

    let up: U32 = scenic_score_dir(heights, height, Range(y - 1, -1, -1), x, true)
    let down: U32 = scenic_score_dir(heights, height, Range(y + 1, heights.size()), x, true)
    let left: U32 = scenic_score_dir(heights, height, Range(x - 1, -1, -1), y, false)
    let right: U32 = scenic_score_dir(heights, height, Range(x + 1, try heights(0)?.size() else 0 end), y, false)

    up * down * left * right

  fun parse(day: U8, env: Env): Array[Array[U8] val] val =>
    recover
      let result: Array[Array[U8] val] = []
      let lines = Input.lines(day, env)
      for line in lines do
        let row: Array[U8] val = recover
          let r: Array[U8] = []
          for n in line.values() do
            r.push(n.u8())
          end
          r
        end
        result.push(row)
      end

      result
    end