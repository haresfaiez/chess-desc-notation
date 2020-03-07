module Board = struct
  type piece =
    | King
    | Queen
  let pieceAt file rank =
    match file with
    | 'K' -> King
    | 'Q' -> Queen
  let at file rank =
    match file with
    | King  -> (
      match rank with
      | 1 -> Some King
      | _ -> None
    )
    | Queen -> Some Queen
end

