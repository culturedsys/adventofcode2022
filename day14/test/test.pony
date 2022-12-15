use "pony_test"
use "collections"
use "itertools"
use "debug"
use ".."


actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestBuildLines)
    test(_TestFill)
    test(_TestFillFloor)


class SSet is (Stringable & Equatable[SSet box])
  let set: Set[Point]

  new create(s: Set[Point]) =>
    set = s

  fun box eq(other: SSet box): Bool =>
    set == other.set

  fun box string(): String iso^ =>
    "{ " + ", ".join(Iter[Point](set.values()).map[String]( {(v: Point) => v.string() })) + " }"


class _TestBuildLines is UnitTest
  fun name(): String => "TestBuildLines"

  fun apply(h: TestHelper) =>
    let actual = Cave.from_lines([[Point(498,4); Point(498,6); Point(496,6)]
        [Point(503,4); Point(502,4); Point(502,9); Point(494,9)]].values())
    let expected: Set[Point] = Set[Point]
    expected.union([
      Point(498, 4); Point(502, 4); Point(503, 4)
      Point(498, 5); Point(502, 5)
      Point(496, 6);  Point(497, 6); Point(498, 6); Point(502, 6)
      Point(502, 7)
      Point(502, 8)
      Point(494, 9); Point(495, 9); Point(496, 9); Point(497, 9); Point(498, 9); Point(499, 9); Point(500, 9); Point(501, 9); Point(502, 9)
    ].values())

    h.assert_eq[SSet](SSet(expected), SSet(actual.filled))


class _TestFill is UnitTest
  fun name(): String => "TestFill"

  fun apply(h: TestHelper) =>
    let actual = Cave.from_lines([[Point(498,4); Point(498,6); Point(496,6)]
        [Point(503,4); Point(502,4); Point(502,9); Point(494,9)]].values())

    h.assert_eq[U32](24, actual.fill_to_abyss(Point(500, 0)))


class _TestFillFloor is UnitTest
  fun name(): String => "TestFillFloor"

  fun apply(h: TestHelper) =>
    let actual = Cave.from_lines([[Point(498,4); Point(498,6); Point(496,6)]
        [Point(503,4); Point(502,4); Point(502,9); Point(494,9)]].values())

    h.assert_eq[U32](93, actual.fill_to_floor(Point(500, 0)))