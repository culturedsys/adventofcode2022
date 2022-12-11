use "pony_test"
use "collections"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestTurn)
    test(_TestRound)
    test(_TestInspections)
    test(_TestParser)


class _TestTurn is UnitTest
  fun name(): String => "TestTurn"

  fun apply(h: TestHelper) =>
    let monkey = Monkey([79; 98], Mul(19), 23, 2, 3)
    let actual = monkey.turn()

    h.assert_array_eq[Throw]([Throw(500, 3); Throw(620, 3)], actual)

class _TestRound is UnitTest
  fun name(): String => "TestRound"

  fun _test(h: TestHelper, results: Array[Array[Item]], monkeys: Monkeys) =>
    try
      for result in results.pairs() do
        h.assert_array_eq[Item](result._2, monkeys(result._1)?.items())
      end
    else
      h.fail("Out of bounds")
    end

  fun apply(h: TestHelper) =>
    let monkeys = Monkeys([
      Monkey([79; 98], Mul(19), 23, 2, 3)
      Monkey([54; 65; 75; 74], Add(6), 19, 2, 0)
      Monkey([79; 60; 97], Square, 13, 1, 3)
      Monkey([73], Add(3), 17, 0, 1)
    ])

    monkeys.round()

    _test(h, [
      [20; 23; 27; 26]
      [2080; 25; 167; 207; 401; 1046]
      []
      []
    ], monkeys)

    monkeys.round()    

    _test(h, [
      [695; 10; 71; 135; 350]
      [43; 49; 58; 55; 362]
      []
      []
    ], monkeys)

    monkeys.round()    

    _test(h, [
      [16; 18; 21; 20; 122]
      [1468; 22; 150; 286; 739]
      []
      []
    ], monkeys)

    for i in Range(0, 7) do
      monkeys.round()
    end

    _test(h, [
      [91; 16; 20; 98]
      [481; 245; 22; 26; 1092; 30]
      []
      []
    ], monkeys)

    for i in Range(0, 10) do
      monkeys.round()
    end

    _test(h, [
      [10; 12; 14; 26; 34]
      [245; 93; 53; 199; 115]
      []
      []
    ], monkeys)

class _TestInspections is UnitTest
  fun name(): String => "TestInspections"

  fun apply(h: TestHelper) =>
    let monkeys = Monkeys([
      Monkey([79; 98], Mul(19), 23, 2, 3)
      Monkey([54; 65; 75; 74], Add(6), 19, 2, 0)
      Monkey([79; 60; 97], Square, 13, 1, 3)
      Monkey([73], Add(3), 17, 0, 1)
    ])

    for i in Range(0, 20) do
      monkeys.round()
    end

    try
      h.assert_eq[U32](101, monkeys(0)?.inspections())
      h.assert_eq[U32](95, monkeys(1)?.inspections())
      h.assert_eq[U32](7, monkeys(2)?.inspections())
      h.assert_eq[U32](105, monkeys(3)?.inspections())
    else
      h.fail("Out of range")
    end


class _TestParser is UnitTest
  fun name(): String => "TestParser"

  fun apply(h: TestHelper) =>
    try
      let monkey = Monkey.parse([
        "Monkey 0:"
        "  Starting items: 79, 98"
        "  Operation: new = old * 19"
        "  Test: divisible by 23"
        "    If true: throw to monkey 2"
        "    If false: throw to monkey 3"
      ].values())?

      h.assert_array_eq[Item]([79; 98], monkey.items())
      h.assert_eq[Monkey](Monkey([79; 98], Mul(19), 23, 2, 3), monkey)
    else
      h.fail("Parse error")
    end