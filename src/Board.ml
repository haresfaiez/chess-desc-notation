module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let get _ = ((King, (Rank 1)), (occupant (King, (Rank 1))))

  let move piece (toFile, toRank) =
    match toRank with
    | 2 -> OccupiedDestination
    | _ -> NoPieceToMove
end

