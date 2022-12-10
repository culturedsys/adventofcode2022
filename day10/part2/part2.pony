use "collections"
use "../../lib"
use ".."


class Vdu is SignalNotifier
  var _col: U8
  let _out: OutStream

  new create(out': OutStream) =>
    _out = out'
    _col = 0

  fun ref signal(x: I32) =>
    if (_col.i32() >= (x - 1)) and (_col.i32() <= (x + 1)) then
      _out.write("#")
    else
      _out.write(".")
    end
    _col = (_col + 1) % 40
    if _col == 0 then
      _out.print("")  
    end


actor Main
  new create(env: Env) =>
    let ops: Array[Op] val = try
      let lines = Input.lines(10, env)
      Assembler.assemble(lines)?
    else
      env.err.print("Parse error")
      return
    end

    let cpu = Cpu(ops, Vdu(env.out))
    cpu.run()
