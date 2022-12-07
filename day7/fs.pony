use "itertools"
use "collections"


class Box[T]
  var _value: T

  new create(value: T^) =>
    _value = value

  fun ref set(value: T^): T =>
    _value = value

  fun get(): this->T =>
    _value


interface Walker
  fun ref apply(d: Directory box)


class Directory
  let _name: String
  let _directories: Array[Directory]
  let _files: Array[File]
  var size: U32

  new create(name: String, directories: Array[Directory], files: Array[File]) =>
    _name = name
    _directories = directories
    _files = files
    size = 0
    _calculate_sizes()

  new parse(lines_base: Iterator[String])? =>
    size = 0
    _name = "/"
    _directories = Array[Directory].create(0)
    _files = Array[File].create(0)
    var current_dir = this
    let dir_stack = Array[Directory].create(0)

    let lines = BufIterator[String](lines_base)
    while true do
      let line = try lines.next()? else break end
      match line
      | "$ ls" => _parse_ls(lines, current_dir)?
      | "$ cd /" => current_dir = this
      | "$ cd .." => 
        current_dir = dir_stack.pop()?
      else 
        let subdir_name = line.split()(2)?
        let subdir = Directory(subdir_name, Array[Directory].create(0), Array[File].create(0))
        current_dir._directories.push(subdir)
        dir_stack.push(current_dir)
        current_dir = subdir
      end
    end 
    _calculate_sizes()

  fun _parse_ls(lines: BufIterator[String], dir: Directory)? =>
    for line in lines do 
      if line(0)? == '$' then
        lines.save(line)
        return
      end
      let parts = line.split()
      if parts(0)? != "dir" then
        dir._files.push(File(parts(1)?, parts(0)?.u32()?))
      end
    end

  fun walk(f: Walker) =>
    f(this)
    for subdir in _directories.values() do
      subdir.walk(f)
    end

  fun find_size_at_most(maximum: U32): U32 =>
    let total = Box[U32](0)
    walk({ (subdir) => 
      if subdir.size <= maximum then
        total.set(total.get() + subdir.size)
      end    
    })
    total.get()

  fun find_smallest_at_least(minimum: U32): U32 =>
    let ret = Box[U32](U32.max_value())
    walk( {(subdir) =>
      if (subdir.size > minimum) and (subdir.size < ret.get()) then
        ret.set(subdir.size)  
      end
    })
    ret.get()
  
  fun ref _calculate_sizes() =>
    if size != 0 then return end
    for file in _files.values() do
      size = size + file.size    
    end

    for subdir in _directories.values() do
      subdir._calculate_sizes()
      size = size + subdir.size
    end
    

class File
  let name: String
  let size: U32

  new create(name': String, size': U32) =>
    name = name'
    size = size'

class BufIterator[T: Any val] is Iterator[T]
  let _base: Iterator[T]
  var _buf: (T | None)

  new create(base: Iterator[T]) =>
    _base = base
    _buf = None

  fun ref has_next(): Bool =>
    match _buf | None => false else true end or _base.has_next()

  fun ref next(): T? =>
    match _buf
    | None => _base.next()?
    | let ret: T => 
      _buf = None
      ret
    end

  fun ref save(t: T) =>
    _buf = t