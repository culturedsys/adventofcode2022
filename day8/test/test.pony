use "pony_test"
use "collections"
use "debug"
use ".."

primitive Fixtures
  fun heights(): Array[Array[U8] val] val =>
    [
      [3; 0; 3; 7; 3]
      [2; 5; 5; 1; 2]
      [6; 5; 3; 3; 2]
      [3; 3; 5; 4; 9]
      [3; 5; 3; 9; 0]
    ]

  fun result(x: USize, y: USize): Array[Array[Bool]] =>
    let r: Array[Array[Bool]] = []
    for i in Range(0, y) do
      let row = Array[Bool].create(0)
      r.push(row)
      for j in Range(0, y) do
        row.push(false)
      end
    end
    r

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    // test(_TestVisibleRow)
    test(_TestVisibleCol)

class _TestVisibleRow is UnitTest
  fun name(): String => "TestVisibleRow"

  fun apply(h: TestHelper) =>
    try
      let hs = Fixtures.heights() 
      var result = Fixtures.result(hs(0)?.size(), hs.size())
  
      Trees.visible_row(hs, 1, Range(0, 5), { (c: Command) =>
        match c
        | let s: Mark => try result(s.y)?(s.x)? = true end
        end
      })

      h.assert_array_eq[Bool]([true; true; false; false; false], result(1)?)

      result = Fixtures.result(hs(0)?.size(), hs.size())
  
      Trees.visible_row(hs, 1, Range(4, 0, -1), { (c: Command) =>
        match c
        | let s: Mark => try result(s.y)?(s.x)? = true end
        end
      })

      h.assert_array_eq[Bool]([false; false; true; false; true], result(1)?)
    else
      h.fail("Error")
    end

class _TestVisibleCol is UnitTest
  fun name(): String => "TestVisibleCol"

  fun apply(h: TestHelper) =>
    try
      let hs = Fixtures.heights() 
      var result = Fixtures.result(hs(0)?.size(), hs.size())
  
      Trees.visible_col(hs, 1, Range(0, 5), { (c: Command) =>
        match c
        | let s: Mark => try result(s.y)?(s.x)? = true end
        end
      })
      
      for case in [true; true; false; false; false].pairs() do 
        h.assert_eq[Bool](case._2, result(case._1)?(1)?)
      end

      result = Fixtures.result(hs(0)?.size(), hs.size())
  
      Trees.visible_col(hs, 1, Range(4, 0, -1), { (c: Command) =>
        match c
        | let s: Mark => try result(s.y)?(s.x)? = true end
        end
      })
      
      for case in [false; false; false; false; true].pairs() do 
        h.assert_eq[Bool](case._2, result(case._1)?(1)?, "Neg: " + case._1.string() + " 1")
      end

    else
      h.fail("Error")
    end