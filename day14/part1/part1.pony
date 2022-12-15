use "../../lib"
use ".."


actor Main
  new create(env: Env) =>
    let lines = Input.lines(14, env)
    var specs = Array[Array[Point]]

    for line in lines do
      let spec = Array[Point]
      for point in line.split_by(" -> ").values() do
        let parts = point.split(",")
        try
          spec.push(Point(parts(0)?.u32()?, parts(1)?.u32()?))
        else
          env.err.print("Parse error: " + line)
          return
        end
      end
      specs.push(spec)
    end

    let cave = Cave.from_lines(specs.values())
    env.out.print(cave.fill(Point(500, 0)).string())