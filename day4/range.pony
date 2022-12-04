class val Range
  let _start: U32
  let _finish: U32

  new val create(s: U32, f: U32) =>
    _start = s
    _finish = f

  fun full_overlap(other: Range): Bool =>
    ((_start >= other._start) and (_finish <= other._finish)) or
      ((other._start >= _start) and (other._finish <= _finish))

  fun partial_overlap(other: Range): Bool =>
    ((_start <= other._finish) and (_finish >= other._start)) or
      ((other._start <= _finish) and (other._finish >= _start))


interface Reporter 
  fun report(message: String)


class LoggingReporter is Reporter
  let _s: OutStream tag

  new create(s: OutStream tag) =>
    _s = s

  fun report(message: String) =>
    _s.print(message)


class Parser is Iterator[(Range, Range)]
  let _base: Iterator[String]
  let _reporter: Reporter

  new create(base: Iterator[String], reporter: Reporter) =>
    _base = base
    _reporter = reporter

  fun ref has_next(): Bool =>
    _base.has_next()

  fun ref next(): (Range, Range)? =>
    let line = _base.next()?
    let parts = line.split(",")
    try
      let first = _parse_part(parts(0)?)?
      let second = _parse_part(parts(1)?)?
      (Range(first._1, first._2), Range(second._1, second._2))
    else
      _reporter.report("Parse error")
      error
    end

  fun _parse_part(part: String): (U32, U32)? =>
    let numbers = part.split("-")
    (numbers(0)?.u32()?, numbers(1)?.u32()?)