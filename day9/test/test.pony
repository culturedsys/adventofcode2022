use "pony_test"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestMove)


class _TestMove is UnitTest
  fun name(): String => "TestMove"

  fun apply(h: TestHelper) =>
    var rope = Rope([Point(1, 0); Point(0, 0)])
    rope.move(Vector(1, 0))

    h.assert_eq[Point](Point(2, 0), rope.head())
    h.assert_eq[Point](Point(1, 0), rope.tail())

    rope = Rope([Point(0, 0); Point(0, 1)])
    rope.move(Vector(0, -1))

    h.assert_eq[Point](Point(0, -1), rope.head())
    h.assert_eq[Point](Point(0, 0), rope.tail())

    rope = Rope([Point(1, -1); Point(0, 0)])
    rope.move(Vector(0, -1))

    h.assert_eq[Point](Point(1, -2), rope.head())
    h.assert_eq[Point](Point(1, -1), rope.tail())
