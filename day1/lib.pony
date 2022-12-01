class Summing is Iterator[U64]
  let _base: Iterator[String]

  new create(base: Iterator[String]) =>
    _base = base

  fun ref has_next(): Bool =>
    _base.has_next()

  fun ref next(): U64 ? =>
    var running: U64 = 0
    while true do
      let line = try _base.next() ? end
      match line
      | None => break
      | "" => break
      | let l: String => let n = l.read_int[U64]()?._1
        running = running + n
      end
    end

    running