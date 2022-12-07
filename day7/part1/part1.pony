use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(7, env)

      let fs = Directory.parse(lines)?

      env.out.print(fs.find_size_at_most(100000).string())
    else
      env.err.print("Parse error")
    end