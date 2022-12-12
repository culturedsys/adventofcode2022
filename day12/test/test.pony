use "pony_test"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestUnvisited)
    test(_TestFindShortest)


class _TestUnvisited is UnitTest
  fun name(): String => "TestPriorityQueue"

  fun apply(h: TestHelper) =>
    try
      let q = Unvisited
      var n = Node(Point(0, 0), 1)
      n.set_distance(2)
      q.add(n)
      
      n = Node(Point(1, 1), 2)
      n.set_distance(1)
      q.add(n)

      n = Node(Point(2, 2), 3)
      n.set_distance(3)
      q.add(n)
      
      let top = q.pop()?

      h.assert_eq[USize](2, q.size())
      h.assert_eq[U32](1, top.distance())
    else
      h.fail("Out of bounds")
    end


class _TestFindShortest is UnitTest
  fun name(): String => "TestFindShortest"

  fun apply(h: TestHelper) =>
    let nodes = 
      Nodes.parse([
        "Sabqponm"
        "abcryxxl"
        "accszExk"
        "acctuvwj"  
        "abdefghi"
      ].values())

    try
      h.assert_eq[U32](31, nodes.find_shortest()?)
    else
      h.fail("Unknown error")
    end