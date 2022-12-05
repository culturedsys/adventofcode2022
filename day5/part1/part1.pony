use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    let lines = Input.lines(5, env)

    try
      let stacks = Stacks.parse(lines)?

      for line in lines do
        try
          let move = Move.parse(line)?
          stacks.move(move)?
        else
          env.err.print("Move error")
          error
        end
      end

      env.out.print(stacks.tops())
    else
      env.err.print("Error")
    end