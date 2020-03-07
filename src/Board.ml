module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  type moveFailure =
    | NotInStartPosition
    | UnauthorizedMove

  let occupant (file, rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let move piece (destinationFile, destinationRank) =
    match destinationRank with
    | 7 -> NotInStartPosition
    | 1 -> UnauthorizedMove
end

