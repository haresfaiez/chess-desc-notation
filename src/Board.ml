module Board = struct
  type piece =
    | King
    | Queen
    | Pawn

  type moveFailure =
    | NotInStartPosition
    | UnauthorizedMove

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  let occupant (file, rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let _occupant (file, Rank rankIndex) = occupant (file, rankIndex)

  let move piece (destinationFile, destinationRank) =
    match destinationRank with
    | 7 -> NotInStartPosition
    | 1 -> UnauthorizedMove
end

