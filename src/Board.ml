module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  type moveFailure =
    | NotInStartPosition

  let occupant (file, rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let move _ _ = NotInStartPosition
end

