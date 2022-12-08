use "pony_test"
use "collections"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestSumming)

  class _TestSumming is UnitTest
    fun name(): String => "TestSumming"

    fun apply(h: TestHelper) =>
      let expected: Array[U64] = [3; 7]
      let actual: Array[U64] = []
      actual.concat(Summing(["1"; "2"; ""; "3"; "4"].values()))
      
      h.assert_array_eq[U64](expected, actual)
