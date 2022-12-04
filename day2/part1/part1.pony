use ".."
use "files"
use "collections"
use "../../lib"

actor Main
  new create(env: Env) =>
    let lines = Input.lines(2, env)

    var total: U32 = 0
    for move in Rps.parse_as_moves(lines) do
      total = total + Rps.score(move._1, move._2)
    end

    env.out.print(total.string())

