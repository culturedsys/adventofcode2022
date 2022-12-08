use "collections"
use "../../lib"
use ".."

actor Counter
  let _env: Env
  let _grid: Array[Array[Bool]]
  var _results: U32
  let _required: U32

  new create(env: Env, x: USize, y: USize, required: U32) =>
    _env = env
    _grid = []
    _results = 0
    _required = required
    
    for i in Range(0, y) do
      let row: Array[Bool] = []
      _grid.push(row)
      for j in Range(0, x) do
        row.push(false)
      end
    end

  be mark(c: Command) =>
    try
      match c
      | let m: Mark => _grid(m.y)?(m.x)? = true
      | Done => 
        _results = _results + 1
        if _results == _required then
          var count: U32 = 0
          for row in _grid.values() do
            for cell in row.values() do
              if cell then
                count = count + 1  
              end
            end
          end
          _env.out.print(count.string())
        end
      end
    else
      _env.err.print("Bad location")
    end


actor TraverseRows 
  new create(heights: Array[Array[U8] val] val, r: USize, range: Range[USize] iso, counter: Counter) =>
    Trees.visible_row(heights, r, consume range, { (c: Command) => counter.mark(c) })


actor TraverseCols
  new create(heights: Array[Array[U8] val] val, col: USize, range: Range[USize] iso, counter: Counter) =>
    Trees.visible_col(heights, col, consume range, { (c: Command) => counter.mark(c) })


actor Main
  new create(env: Env) =>
    try
      let heights = Trees.parse(8, env)

      let rows = heights.size()
      let cols = heights(0)?.size()
      let counter = Counter(env, cols, rows, (rows + cols).u32())

      for i in Range(0, rows) do
        TraverseRows(heights, i, Range(0, cols), counter)
        TraverseRows(heights, i, Range(cols - 1, 0, -1), counter)
      end

      for i in Range(0, cols) do
        TraverseCols(heights, i, Range(0, rows), counter)
        TraverseCols(heights, i, Range(rows - 1, 0, -1), counter)
      end

    else
      env.err.print("Error")
    end