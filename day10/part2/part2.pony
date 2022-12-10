use "collections"
use "../../lib"

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(10, env)

      let signal: Array[I32] = []
      var x: I32 = 1
      for line in lines do
        let parts = line.split()
        match parts(0)?
        | "noop" => signal.push(x)
        | "addx" =>
            signal.push(x)
            signal.push(x)
            x = x + parts(1)?.i32()?
        end
      end

      for row in Range(0, 6) do
        for col in Range(0, 40) do
          let value = signal((row * 40) + col)?
          if (col.i32() >= (value - 1)) and (col.i32() <= (value + 1)) then  
            env.out.write("▓")
          else
            env.out.write("░")
          end
        end
        env.out.print("")
      end


    else
      env.err.print("Parse error")
    end