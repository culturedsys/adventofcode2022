use ".."
use "files"
use "collections"

actor Main
  new create(env: Env) =>
    let input = File.open(FilePath.create(FileAuth.create(env.root), "inputs/day2.txt"))  
    let lines = FileLines.create(input)
    let rps: Rps val = Rps

    var total: U32 = 0
    for move in rps.parse_as_moves(lines) do
      total = total + rps.score(move._1, move._2)
    end

    env.out.print(total.string())

