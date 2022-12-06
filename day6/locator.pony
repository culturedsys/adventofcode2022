use "itertools"
use "collections"

primitive Locator

  fun _group(s: String, start: USize, n: USize): Iter[U8] =>
    Iter[U8](s.values()).skip(start).take(n)

  fun _unique(i: Iter[U8], n: USize): Bool =>
    let s = Set[U8]
    s.union(i)
    s.size() == n

  fun locate(string: String, n: USize): USize? =>
    for i in Range[USize](0, string.size() - n) do
      if _unique(_group(string, i, n), n) then
        return i + n  
      end
    end

    error