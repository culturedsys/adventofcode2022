use "pony_test"
use ".."

actor Main is TestList
  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_TestFindBySize)
    test(_TestParse)


class _TestFindBySize is UnitTest
  fun name(): String => "TestFindSizeAtMost"

  fun apply(h: TestHelper) =>
    let fs = Directory("/",
      [
        Directory("a", 
          [
            Directory("e", [], 
            [
              File("i", 584)
            ])
          ], 
          [
            File("f", 29116)
            File("g", 2557)
            File("h.lst", 62596)
          ]
        )
        Directory("d",
          [],
          [
            File("j", 4060174)
            File("d.log", 8033020)
            File("d.ext", 5626152)
            File("k", 7214296)
          ]
        )
      ],
      [
        File("b.txt", 14848514)
        File("c.dat", 8504156)
      ]
    )

    h.assert_eq[U32](95437, fs.find_size_at_most(100000))


class _TestParse is UnitTest
  fun name(): String => "TestParse"

  fun apply(h: TestHelper) =>
    try
      let actual = Directory.parse([
        "$ cd /"
        "$ ls"
        "dir a"
        "100 b"
        "$ cd a"
        "$ ls"
        "200 c"
        "$ cd .."
      ].values())?
    else
      h.fail("Parse error")
    end
