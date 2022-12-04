use "files"
use "collections"
use ".."
use "../../lib"

actor Main
  new create(env: Env) =>
    try
      let lines = Input.lines(3, env)
      var total: U64 = 0
      while true do
        let first = Set[U8]
        let second = Set[U8]
        let third = Set[U8]
        try
          first.union(lines.next()?.values())
          second.union(lines.next()?.values())
          third.union(lines.next()?.values())
        else
          break
        end
        first.intersect(second)
        first.intersect(third)
        let dup = first.values().next()?
        let value = Pack.priority(dup) 
        total = total + value.u64()
      end
      env.out.print(total.string())
    else
      env.out.print("Error")
    end