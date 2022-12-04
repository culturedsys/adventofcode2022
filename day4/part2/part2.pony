use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    let lines = Input.lines(4, env)
    
    var count: U32 = 0
    for pair in Parser(lines, LoggingReporter(env.err)) do
      if pair._1.partial_overlap(pair._2) then
        count = count + 1
      end
    end

    env.out.print(count.string())     
