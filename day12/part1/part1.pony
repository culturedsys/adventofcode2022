use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    let nodes = Nodes.parse(Input.lines(12, env))
    try
      env.out.print(nodes.find_shortest()?.string())
    else
      env.err.print("Bad input")
    end