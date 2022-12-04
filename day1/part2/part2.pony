use "files"
use ".."
use "../../lib"

actor Main
  new create(env: Env) =>
      let lines = Input.lines(1, env)
      var maxs: Array[U64] = [0; 0; 0]
      for running in Summing(lines) do
        maxs = add_if_gt(maxs, running)
      end
      env.out.print(sum(maxs).string())

    fun add_if_gt(a: Array[U64], i: U64): Array[U64] =>
      let ret: Array[U64] = []
      let iter = a.values()
      for v in iter do
        if i >= v then
          ret.push(i)
          ret.push(v)
          ret.concat(iter)
          break
        end
        ret.push(v)
      end
      ret.truncate(a.size())
      ret

    fun sum(a: Array[U64]): U64 =>
      var total: U64 = 0
      let iter = a.values()
      for v in iter do
        total = total + v
      end
      total