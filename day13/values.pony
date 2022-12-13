use "itertools"
use "debug"
use c = "collections"


trait val Value is (Stringable & Equatable[Value] & Comparable[Value])
  fun box compare(other: Value box): Compare =>
    let self: Value box = this
    match (self, other)
    | (let fc: Constant box, let sc: Constant box) => 
      if fc.value < sc.value then
        return Less
      elseif fc.value > sc.value then
        return Greater
      else
        return Equal
      end
    | (let fc: Constant box, let sl: List box) => return List([Constant(fc.value)]).compare(sl)
    | (let fl: List box, let sc: Constant box) => return fl.compare(List([Constant(sc.value)]))
    | (let fl: List box, let sl: List box) => 
      for i in c.Range(0, fl.value.size().max(sl.value.size())) do
        let f = try fl.value(i)? else return Less end
        let s = try sl.value(i)? else return Greater end
        let comp = f.compare(s) 
        if comp != Equal then
          return comp
        end
      end
    end

    Equal

  fun box eq(other: Value): Bool =>
    compare(other) == Equal

  fun box lt(other: Value): Bool =>
    compare(other) == Less


class val Constant is Value
  let value: U8
  new val create(value': U8) =>
    value = value'

  fun string(): String iso^ => value.string()


class val List is Value
  let value: Array[Value] val
  new val create(value': Array[Value] val) =>
    value = value'
  
  fun string(): String iso^ =>
    "[" + ",".join(Iter[Value](value.values()).map[String]({ (v: Value) => v.string()})) + "]"


primitive Values
  fun _parse(i: USize, s: String): (Value, USize)? =>
    if s(i)? == '[' then
      var p = i + 1
      let ret: Array[Value] iso = []
      while s(p)? != ']' do
        let read = _parse(p, s)?
        p = read._2
        if s(p)? == ',' then p = p + 1 end
        ret.push(read._1)
      end
      (List(consume ret), p + 1)
    else
      let read = s.read_int[U8](i.isize())?
      (Constant(read._1), i + read._2)
    end

  fun parse(s: String): Value? =>
    _parse(0, s)?._1
