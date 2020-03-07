module Board = struct
  type piece =
    | King
    | Queen

  let at file rank =
    match file with
    | King  -> (
      match rank with
      | 1 -> Some King
      | _ -> None
    )
    | Queen -> Some Queen
end

