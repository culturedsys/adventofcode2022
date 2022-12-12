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
      env.out.print(nodes.find_shortest_of_many()?.string())
    else
      env.err.print("Bad input")
    end