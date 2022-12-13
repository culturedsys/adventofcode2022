use "pony_test"
use ".."


actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestCompare)
    test(_TestParse)


class _TestCompare is UnitTest
  fun name(): String => "TestCompare"

  fun apply(h: TestHelper) =>
    var first: Value
    var second: Value

    first = List([List([Constant(1)]); List([Constant(2); Constant(3); Constant(4)])])
    second = List([List([Constant(1)]); Constant(4)])
    h.assert_true(first < second)

    first = List([Constant(1); Constant(1); Constant(3); Constant(1); Constant(1)])
    second = List([Constant(1); Constant(1); Constant(5); Constant(1); Constant(1)])
    h.assert_true(first < second)

    first = List([Constant(9)])
    second = List([List([Constant(8); Constant(7); Constant(6)])])
    h.assert_true(first > second)

    first = List([
      Constant(1)
      List([
        Constant(2)
        List([Constant(3); List([Constant(4); List([Constant(5); Constant(6); Constant(7)])])])
      ])
      Constant(8)
      Constant(9)
    ])
    second = List([
      Constant(1)
      List([
        Constant(2)
        List([Constant(3); List([Constant(4); List([Constant(5); Constant(6); Constant(0)])])])
      ])
      Constant(8)
      Constant(9)
    ])

    h.assert_true(first > second)


class _TestParse is UnitTest
  fun name(): String => "TestParse"

  fun apply(h: TestHelper) =>
    try
      h.assert_eq[Value](
        List([
          Constant(1)
          List([
            Constant(2)
            List([Constant(3); List([Constant(4); List([Constant(5); Constant(6); Constant(7)])])])
          ])
          Constant(8)
          Constant(9)
        ]),
        Values.parse("[1,[2,[3,[4,[5,6,7]]]],8,9]")?
      )
    else
      h.fail("Parse error")
    end