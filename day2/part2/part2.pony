use ".."
use "files"
use "collections"

actor Main
  new create(env: Env) =>
    let input = File.open(FilePath.create(FileAuth.create(env.root), "inputs/day2.txt"))  
    let lines = FileLines.create(input)

    var total: U32 = 0
    for goal in Rps.parse_as_goals(lines) do
      let opponent = goal._1
      let self = hand_for_goal(opponent, goal._2)
      total = total + Rps.score(opponent, self)
    end

    env.out.print(total.string())

  fun hand_for_goal(opponent: Hand, goal: Result): Hand =>
    match (opponent, goal) 
    | (Rock, Win) => Paper
    | (Paper, Win) => Scissors
    | (Scissors, Win) => Rock
    | (Rock, Lose) => Scissors
    | (Paper, Lose) => Rock
    | (Scissors, Lose) => Paper
    else opponent
    end