use "files"
use ".."

actor Main
  new create(env: Env) =>
    let input = File.open(FilePath.create(FileAuth.create(env.root), "inputs/day1.txt"))  
    let lines = FileLines.create(input)
    var max: U64 = 0
    for running in Summing(lines) do
        if running > max then max = running end
    end
    env.out.print(max.string())
