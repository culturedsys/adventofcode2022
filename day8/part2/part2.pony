use "collections"
use "../../lib"
use ".."

actor Counter
  let _env: Env
  var _max: U32
  var _results: USize
  let _required: USize

  new create(env: Env, required: USize) =>
    _env = env
    _max = 0
    _results = 0
    _required = required
    
  be mark(x: USize, y: USize, score: U32) =>
    if score > _max then _max = score end
    _results = _results + 1
    if _results == _required then
      _env.out.print(_max.string())
    end


actor Calculate
  new create(heights: Array[Array[U8] val] val, x: USize, y: USize, counter: Counter) =>
    counter.mark(x, y, Trees.scenic_score(heights, x, y))


actor Main
  new create(env: Env) =>
    try
      let heights: Array[Array[U8] val] val = Trees.parse(8, env)

      let rows = heights.size()
      let cols = heights(0)?.size()
      let counter = Counter(env, (cols - 2) * (rows - 2))

      for y in Range(1, rows - 1) do
        for x in Range(1, cols - 1) do
          Calculate(heights, x, y, counter)
        end
      end

    else
      env.err.print("Error")
    end