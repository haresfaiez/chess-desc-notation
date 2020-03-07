module Board = struct
  type piece =
    | King
    | Queen

  let occupant file rank =
    match file with
    | King  -> (
      match rank with
      | 1 -> Some King
      | _ -> None
    )
    | Queen -> Some Queen
end

