use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(9, env)

      let trail = Trail(Rope([Point(0, 0); Point(0, 0)]), lines)?
      env.out.print(trail.follow().string())
    else
      env.err.print("Parse error")
    end