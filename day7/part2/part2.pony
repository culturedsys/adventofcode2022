use "../../lib"
use ".."
use "itertools"

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(7, env)

      let fs = Directory.parse(lines)?

      var total: U32 = fs.size
      let unused: U32 = 70000000 - total
      let minimum: U32 = 30000000 - unused

      env.out.print(fs.find_smallest_at_least(minimum).string())
    else
      env.err.print("Parse error")
    end