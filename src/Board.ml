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

  type square = (position * (piece option))

  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let get position = (position, (occupant position))

  let move subject (toFile, (Rank toRank)) occupant =
    match occupant with
    | Some piece -> OccupiedDestination
    | None       -> match toRank with
                    | 2 -> OccupiedDestination
                    | _ -> NoPieceToMove
end

