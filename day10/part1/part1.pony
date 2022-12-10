use "../../lib"
use ".."


class SignalSampler is SignalNotifier
  var _total: I32
  var _cycle: U32
  let _samples: Array[U32] val

  new create(samples': Array[U32] val) =>
    _samples = samples'
    _total = 0
    _cycle = 1

  fun ref signal(x: I32) =>
    if _samples.contains(_cycle) then
      _total = _total + (x * _cycle.i32())  
    end
    _cycle = _cycle + 1

  fun total(): I32 => _total


actor Main
  new create(env: Env) =>
    let ops: Array[Op] val = try
      let lines = Input.lines(10, env)
      Assembler.assemble(lines)?
    else
      env.err.print("Parse error")
      return
    end

    let sampler = SignalSampler([20; 60; 100; 140; 180; 220])
    let cpu = Cpu(ops, sampler)
    cpu.run()
    env.out.print(sampler.total().string())
