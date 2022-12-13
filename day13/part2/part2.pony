use c = "collections"
use "../../lib"
use ".."


actor Main
  new create(env: Env) =>
    let first = List([List([Constant(2)])])
    let second = List([List([Constant(6)])])
    let values: Array[Value] = [first; second]

    for line in Input.lines(13, env) do
      if line == "" then
        continue
      end
      try
        values.push(Values.parse(line)?)
      else
        env.err.print("Parse error: " + line)
        return
      end
    end

    c.Sort[Array[Value], Value](values)

    let first_idx = try
        values.find(first where predicate = {(x, y) => x == y})?
      else
        env.err.print("Could not find first")
        return
      end
    let second_idx = try
        values.find(second where predicate = {(x, y) => x == y})?
      else
        env.err.print("Could not find second")
        return
      end

    env.out.print(((first_idx + 1) * (second_idx + 1)).string())