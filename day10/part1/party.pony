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

      env.out.print(((signal(19)? * 20) + 
        (signal(59)? * 60) + 
        (signal(99)? * 100) + 
        (signal(139)? * 140) + 
        (signal(179)? * 180) + 
        (signal(219)? * 220)).string())

    else
      env.err.print("Parse error")
    end