use "files"

primitive Input
  fun lines(day: U8, env: Env): Iterator[String] =>
    let input = File.open(FilePath.create(FileAuth.create(env.root), "inputs/day" + day.string() + ".txt"))  
    FileLines.create(input)
