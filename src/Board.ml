module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  let occupant file rank =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None
end

