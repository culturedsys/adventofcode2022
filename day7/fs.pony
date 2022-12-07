use "itertools"

class Directory
  let _name: String
  let _directories: Array[Directory]
  let _files: Array[File]

  new create(name: String, directories: Array[Directory], files: Array[File]) =>
    _name = name
    _directories = directories
    _files = files

  new parse(lines_base: Iterator[String])? =>
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

  fun find_size_at_most(size: U32): U32 =>
    _traverse(size)._2

  fun _traverse(size: U32): (U32, U32) =>
    var total: U32 = 0
    
    for file in _files.values() do
      total = total + file.size    
    end

    var matching_subdirs_size: U32 = 0

    for subdir in _directories.values() do
      let from_subdir = subdir._traverse(size)
      let size_subdir = from_subdir._1
      total = total + size_subdir
      matching_subdirs_size = matching_subdirs_size + from_subdir._2
      if size_subdir <= size then
        matching_subdirs_size = matching_subdirs_size + size_subdir
      end
    end

    (total, matching_subdirs_size)


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