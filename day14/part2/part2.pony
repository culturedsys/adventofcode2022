use "../../lib"
use ".."


actor Main
  new create(env: Env) =>
    let lines = Input.lines(14, env)
    var specs = try
      Caves.parse(lines)?
    else
      env.err.print("Parse error")
      return
    end

    let cave = Cave.from_lines(specs.values())
    env.out.print(cave.fill_to_floor(Point(500, 0)).string())