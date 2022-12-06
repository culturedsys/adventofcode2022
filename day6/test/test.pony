use "pony_test"
use ".."

actor Main is TestList  
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestLocator)

class _TestLocator is UnitTest
  fun name(): String => "TestLocator"

  fun apply(h: TestHelper) =>
    try
      h.assert_eq[USize](7, Locator.locate("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 4)?)
      h.assert_eq[USize](6, Locator.locate("nppdvjthqldpwncqszvftbrmjlhg", 4)?)
      h.assert_eq[USize](10, Locator.locate("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 4)?)
    else  
      h.fail("Error")
    end