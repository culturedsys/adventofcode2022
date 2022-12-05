use "itertools"

class val Move is (Equatable[Move] & Stringable)
  let count: U32
  let from: USize
  let to: USize

  new val create(c: U32, f: USize, t: USize) =>
    count = c
    from = f
    to = t

  new val parse(line: String)? =>
    let words: Array[String] = line.split()
    count = words(1)?.u32()?
    from = words(3)?.usize()? - 1
    to = words(5)?.usize()? - 1

  fun box eq(other: Move): Bool =>
    (count == other.count) and (from == other.from) and (to == other.to)

  fun box string(): String iso^ =>
    "Move " + count.string() + " from " + from.string() + " to " + to.string()


class Stacks is (Equatable[Stacks] & Stringable)
  let _stacks: Array[Array[U8] ref] ref

  new from(stacks: Array[Array[U8]]) =>
    _stacks = stacks

  new parse(lines: Iterator[String])? =>
    let stacks = Array[(Array[U8] | None)].init(None, 255)

    for line in lines do
      if line == "" then break end
      for indexed_char in Iter[U8](line.values()).enum() do
        let index = indexed_char._1
        let char = indexed_char._2
        if (char >= '0') and (char <= '9') then
          break  
        end
        if (char >= 'A') and (char <= 'Z') then
          let stack_index: USize = ((index - 1) / 4).usize()
          match stacks(stack_index)?
          | None => stacks(stack_index)? = Array[U8].init(char, 1)
          | let stack: Array[U8] => stack.unshift(char)
          end
        end
      end
    end

    stacks.reverse_in_place()
    _stacks = Array[Array[U8]].create(0)
    for stack in Iter[(Array[U8]|None)](stacks.values())
      .skip_while({(x) => match x | None => true else false end}) do
      match stack 
      | None => _stacks.push(Array[U8].create(0))
      | let s: Array[U8] => _stacks.push(s)
      end
    end
    _stacks.reverse_in_place()

  fun box string(): String iso^ =>
    var ret: String iso = recover String end
    ret = ret + "Stack("
    for stack in _stacks.values() do
      ret = ret + "["
      for sign in stack.values() do
        ret = ret + String.from_array([sign; ' '])
      end
      ret = ret + "] "
    end
    ret = ret + ")"
    ret

  fun ref move(movement: Move): None ? =>
    var count: U32 = 0
    while count < movement.count do
      let item: U8 = _stacks(movement.from)?.pop()?
      _stacks(movement.to)?.push(item)
      count = count + 1
    end

  fun ref move_block(movement: Move): None ? =>
    let f = _stacks(movement.from)?
    let t = _stacks(movement.to)?
    for item in f.slice(f.size() - movement.count.usize()).values() do
      t.push(item)
    end
    f.trim_in_place(0, f.size() - movement.count.usize())       

  fun box eq(other: Stacks box): Bool => 
    if _stacks.size() != other._stacks.size() then return false end
    let self_it = _stacks.values()
    let other_it = other._stacks.values()
    try
      while self_it.has_next() and other_it.has_next() do
        let self_i = self_it.next()?
        let other_i = other_it.next()?
        if self_i.size() != other_i.size() then return false end
        let self_i_it = self_i.values()
        let other_i_it = other_i.values()
        while self_i_it.has_next() and other_i_it.has_next() do
          if self_i_it.next()? != other_i_it.next()? then return false end
        end
      end
    else
      return false
    end

    true

  fun box tops(): String =>
    let ret: Array[U8] iso = Array[U8].create(_stacks.size())

    for stack in _stacks.values() do
      ret.push(try stack(stack.size() - 1)? else ' ' end)
    end

    String.from_iso_array(consume ret)