primitive  Pack
  fun priority(item: U8): U8 =>
    if (item >= 'a') and (item <= 'z') then ((item - 'a') + 1) else ((item - 'A') + 27) end
