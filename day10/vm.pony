primitive Noop
class val Addx
  let param: I32
  
  new val create(param': I32) =>
    param = param'

type Op is (Noop | Addx)

primitive Assembler
  fun assemble(lines: Iterator[String]): Array[Op] val? =>
    let ops: Array[Op] iso = []
    for line in lines do
      let parts = line.split()
      match parts(0)?
      | "noop" => ops.push(Noop)
      | "addx" =>
          ops.push(Addx(parts(1)?.i32()?))
      end
    end
    ops

interface SignalNotifier
  fun ref signal(value: I32)

class Cpu
  var _x: I32
  let _ops: Array[Op] val
  let _notifier: SignalNotifier

  new create(ops': Array[Op] val, notifier': SignalNotifier) =>
    _x = 1
    _ops = ops'
    _notifier = notifier'

  fun ref run() =>
    for op in _ops.values() do
      match op
      | Noop => _notifier.signal(_x)
      | let addx: Addx =>
        _notifier.signal(_x)
        _notifier.signal(_x)
        _x = _x + addx.param
      end
    end
