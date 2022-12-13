use "../../lib"
use ".."


actor Main
  new create(env: Env) =>
    var index: U32 = 1
    var result: U32 = 0
    let lines = Input.lines(13, env)
    while true do
      let first_line = try lines.next()? else break end
      let second_line = try lines.next()? else break end
      let first = try
        Values.parse(first_line)?
      else
        env.err.print("Parse error: " + first_line)
        return
      end
      let second = try
        Values.parse(second_line)?
      else
        env.err.print("Parse error: " + second_line)
        return
      end

      if first < second then
        result = result + index   
      end

      index = index + 1
      try lines.next()? else break end
    end

    env.out.print(result.string())