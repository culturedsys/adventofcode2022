use "pony_test"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestMove)
    test(_TestParseStacks)
    test(_TestParseMove)
    test(_TestMoveBlock)

class iso _TestMove is UnitTest
  fun name(): String => "TestMove"

  fun apply(h: TestHelper) =>
    let stacks = Stacks.from([['Z'; 'N'; 'D']; ['M'; 'C']; ['P']])
    try stacks.move(Move(3, 0, 2))? 
    else 
      h.fail("Move failed")
    end

    h.assert_eq[Stacks](Stacks.from([[]; ['M'; 'C']; ['P'; 'D'; 'N'; 'Z']]), stacks)


class iso _TestParseStacks is UnitTest
  fun name(): String => "TestParseStacks"

  fun apply(h: TestHelper) =>
    try    
      let stacks = Stacks.parse(
        [
        "    [D]"    
        "[N] [C]"    
        "[Z] [M] [P]"
        " 1   2   3" 
        ""
        ].values()
      )?

      h.assert_eq[Stacks](Stacks.from([['Z'; 'N'];['M'; 'C'; 'D']; ['P']]), stacks)
    else
      h.fail("Parse failed")
    end


class iso _TestParseMove is UnitTest
  fun name(): String => "TestParseMove"

  fun apply(h: TestHelper) =>
    try
      let move = Move.parse("move 10 from 2 to 1")?
      h.assert_eq[Move](Move(10, 1, 0), move)
    else
      h.fail("Parse failed")
    end


class iso _TestMoveBlock is UnitTest
  fun name(): String => "TestMoveBlock"

  fun apply(h: TestHelper) =>
    let stacks = Stacks.from([['Z'; 'N'; 'D']; ['M'; 'C']; ['P']])
    try 
      stacks.move_block(Move(3, 0, 2))? 
    else 
      h.fail("Move failed")
    end

    h.assert_eq[Stacks](Stacks.from([[]; ['M'; 'C']; ['P'; 'Z'; 'N'; 'D']]), stacks)
