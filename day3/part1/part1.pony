use "files"
use "collections"
use ".."
use "../../lib"

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(3, env)
      var total: U64 = 0
      for line in lines do
        let first = Set[U8]
        let second = Set[U8]
        first.union(line.cut(0, line.size().isize() / 2).values())
        second.union(line.cut(line.size().isize() / 2, line.size().isize()).values())
        first.intersect(second)
        let dup = first.values().next()?
        let value = Pack.priority(dup) 
        total = total + value.u64()
      end
      env.out.print(total.string())
    else
      env.out.print("Error")
    end