use "itertools"


type Item is U64
type Id is USize

trait val Operation is (Equatable[Operation] & Stringable)
  fun apply(left: Item): Item

class val Add is Operation
  let right: Item

  new val create(right': Item) =>
    right = right'

  fun apply(left: Item): Item =>
    left + right

  fun eq(other: Operation): Bool =>
    match other 
    | let o: Add => right == o.right
    else false
    end

  fun string(): String iso^ =>
    "Add(" + right.string() + ")"

class val Mul is Operation
  let right: Item

  new val create(right': Item) =>
    right = right'

  fun apply(left: Item): Item =>
    left * right

  fun eq(other: Operation): Bool =>
    match other 
    | let o: Mul => right == o.right
    else false
    end
  
  fun string(): String iso^ =>
    "Mul(" + right.string() + ")"  


class val Square is Operation
  fun apply(left: Item): Item =>
    left * left

  fun eq(other: Operation): Bool =>
    match other
    | let _: Square => true
    else false
    end

  fun string(): String iso^ =>
    "Square" + ""


class val Throw is (Equatable[Throw] & Stringable)
  let item: Item
  let target: Id

  new val create(item': Item, target': Id) =>
    item = item'
    target = target'

  fun eq(other: Throw): Bool =>
    (item == other.item) and (target == other.target)

  fun string(): String iso^ =>
    item.string() + "->" + target.string()


class Monkey is (Equatable[Monkey] & Stringable)
  let _items: Seq[Item]
  let _operation: Operation
  let _divisor: Item
  let _true_target: Id
  let _false_target: Id
  var _inspections: U32

  new create(items': Seq[Item], operation': Operation, divisior': Item, true_target': Id, false_target': Id) =>
    _items = items'
    _operation = operation'
    _divisor = divisior'
    _true_target = true_target'
    _false_target = false_target'
    _inspections = 0

  new parse(lines: Iterator[String])? =>
    _inspections = 0
    lines.next()? // skip monkey definition
    let items_line = _get_line(lines, 3)?
    _items = Iter[String](items_line(2)?.split_by(", ").values())
      .map[Item]({ (i): Item? => i.u64()? }).collect(Array[Item])

    let operation_line = _get_line(lines)?
    _operation = match operation_line(4)?
    | "+" => Add(operation_line(5)?.u64()?)
    | "*" => match operation_line(5)? 
      | "old" => Square
      else Mul(operation_line(5)?.u64()?) 
      end
    else 
      error
    end

    let divisor_line = _get_line(lines)?
    _divisor = divisor_line(3)?.u64()?

    let true_target_line = _get_line(lines)?
    _true_target = true_target_line(5)?.usize()?

    let false_target_line = _get_line(lines)?
    _false_target = false_target_line(5)?.usize()?

  fun tag _get_line(lines: Iterator[String], n: USize = 0): Array[String]? =>
    let line = lines.next()?.clone()
    line.strip()
    line.split(" ", n)

  fun ref turn(): Seq[Throw] =>
    let result: Seq[Throw] = []
   
    while true do
      var item = try _items.shift()? else break end
      _inspections = _inspections + 1
      item = _operation(item) / 3
      result.push(Throw(item, if (item % _divisor) == 0 then _true_target else _false_target end))
    end

    result

  fun ref catch(item: Item) =>
    _items.push(item)

  fun box items(): Seq[Item] box =>
    _items

  fun box inspections(): U32 =>
    _inspections

  fun eq(other: Monkey box): Bool =>
    (_operation == other._operation) and 
      (_divisor == other._divisor) and 
      (_true_target == other._true_target) and
      (_false_target == other._false_target)

  fun string(): String iso^ =>
    "Monkey(items=[" + ", ".join(_items.values()) + 
      "] operation=" + _operation.string() + 
      ", divisor=" + _divisor.string() + 
      ", true_target=" + _true_target.string() + 
      ", false_target=" + _false_target.string() + 
      ")"


class Monkeys
  let _monkeys: Seq[Monkey]

  new create(monkeys': Seq[Monkey]) =>
    _monkeys = monkeys'

  new parse(lines: Iterator[String]) =>
    _monkeys = []
    while true do
      try
        _monkeys.push(Monkey.parse(lines)?)
        lines.next()?
      else
        break
      end
    end

  fun ref round() =>
    for monkey in _monkeys.values() do
      for throw in monkey.turn().values() do
        try
          _monkeys(throw.target)?.catch(throw.item)
        end
      end
    end

  fun apply(id: Id): Monkey box? =>
    _monkeys(id)?

  fun ref monkeys(): Array[Monkey] =>
    let ret = Array[Monkey](_monkeys.size())
    ret.concat(_monkeys.values())
    ret