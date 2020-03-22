module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  type moveFailure =
    | NotInStartPosition
    | UnauthorizedMove

  type rank =
    | Rank of int

  let occupant (file, rank : piece * int) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let _occupant (file, rank: piece * rank) = None

  let move piece (destinationFile, destinationRank) =
    match destinationRank with
    | 7 -> NotInStartPosition
    | 1 -> UnauthorizedMove
end

