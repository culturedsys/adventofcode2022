use "itertools"
use "collections"

primitive Locator

  fun locate(string: String, n: USize): USize? =>
    let m = Map[U8, USize]

    for c in Iter[U8](string.values()).take(n) do
      m.upsert(c, 1, {(n, _) => n + 1})
    end

    if m.size() == n then
      return n  
    end

    var start: USize = 1
    var finish: USize = n
    while finish < string.size() do
      let at_start = string(start - 1)?
      let at_finish = string(finish)?

      if m(at_start)? == 1 then
        m.remove(at_start)?
      else
        m(at_start) = m(at_start)? - 1
      end

      m.upsert(at_finish, 1, {(n, _) => n + 1})

      if m.size() == n then
        return finish + 1
      end

      start = start + 1
      finish = finish + 1
    end

    error