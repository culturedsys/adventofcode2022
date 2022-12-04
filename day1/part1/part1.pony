use "files"
use ".."
use "../../lib"

actor Main
  new create(env: Env) =>
    let lines = Input.lines(1, env)
    var max: U64 = 0
    for running in Summing(lines) do
        if running > max then max = running end
    end
    env.out.print(max.string())
