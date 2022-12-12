use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    let nodes = try 
      Nodes.parse(Input.lines(12, env))?
    else
      env.err.print("Parse error")
      return
    end
    try
      env.out.print(nodes.find_shortest_to_finish()?.string())
    else
      env.err.print("Bad input")
    end