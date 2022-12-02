use "itertools"
use "collections"

primitive Rock
primitive Paper
primitive Scissors

type Hand is (Rock | Paper | Scissors)

primitive Win
primitive Lose
primitive Draw

type Result is (Win | Lose | Draw)

class Rps
  fun result(opponent: Hand, self: Hand): Result =>
    match (opponent, self)
    | (Rock, Paper) => Win
    | (Paper, Rock) => Lose
    | (Paper, Scissors) => Win
    | (Scissors, Paper) => Lose
    | (Scissors, Rock) => Win
    | (Rock, Scissors) => Lose
    else Draw
    end

  fun score(opponent: Hand, self: Hand): U32 =>
    let score_for_hand: U32 = match self 
    | Rock => 1
    | Paper => 2
    | Scissors => 3
    end

    let score_for_result: U32 = match result(opponent, self)
    | Lose => 0
    | Draw => 3
    | Win => 6
    end

    score_for_hand + score_for_result

  fun parse_as_moves(source: Iterator[String]): Iter[(Hand, Hand)] =>
    Iter[String](source).map[(Hand, Hand)]({(s)? => 
      let parts = s.split(" ")
      let opponent: Hand val = match parts(0)?
      | "A" => Rock
      | "B" => Paper
      | "C" => Scissors
      else error
      end
      let self: Hand val = match parts(1)?
      | "X" => Rock
      | "Y" => Paper
      | "Z" => Scissors
      else error
      end

      (opponent, self)
    })

  fun parse_as_goals(source: Iterator[String]): Iter[(Hand, Result)] =>
    Iter[String](source).map[(Hand, Result)]({(s)? => 
      let parts = s.split(" ")
      let opponent: Hand val = match parts(0)?
      | "A" => Rock
      | "B" => Paper
      | "C" => Scissors
      else error
      end
      let goal: Result val = match parts(1)?
      | "X" => Lose
      | "Y" => Draw
      | "Z" => Win
      else error
      end

      (opponent, goal)
    })

