use "pony_test"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestFindShortest)
    test(_TestFindMultiple)


class _TestFindShortest is UnitTest
  fun name(): String => "TestFindShortest"

  fun apply(h: TestHelper) =>
    let nodes = try
      Nodes.parse([
        "Sabqponm"
        "abcryxxl"
        "accszExk"
        "acctuvwj"  
        "abdefghi"
      ].values())?
    else
      h.fail("Parse error")
      return
    end

    try
      h.assert_eq[U32](31, nodes.find_shortest_to_finish()?)
    else
      h.fail("Unknown error")
    end

class _TestFindMultiple is UnitTest
  fun name(): String => "TestFindMultiple"

  fun apply(h: TestHelper) =>
    let nodes = try
      Nodes.parse([
        "Sabqponm"
        "abcryxxl"
        "accszExk"
        "acctuvwj"  
        "abdefghi"
      ].values())?
    else
      h.fail("Parse error")
      return
    end

    try
      h.assert_eq[U32](29, nodes.find_shortest_to_lowest()?)
    else
      h.fail("Unknown error")
    end
