use "collections"
use "itertools"
use "../../lib"
use ".."

actor Main
  new create(env: Env) =>
    let monkeys = Monkeys.parse(Input.lines(11, env))
    for i in Range(0, 20) do
      monkeys.round()
    end

    let results = Iter[Monkey](monkeys.monkeys().values()).map[U32]({ (m) => m.inspections()})
      .collect(Array[U32])
    
    Sort[Array[U32], U32](results)
    try
      env.out.print((results(results.size() - 1)? * results(results.size() - 2)?).string())
    else
      env.err.print("Out of bounds")
    end