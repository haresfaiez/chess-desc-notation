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

  type _square =
    | Occupied: position * piece -> _square
    | Empty   : position -> _square
  
  let occupant (file, Rank rank) =
    let piece = match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None in
    ((file, Rank rank), piece)

  let _move piece destination =
    match destination with
    | Occupied (position, piece) -> OccupiedDestination
    | Empty (file, (Rank rank))  -> match rank with
                                    | _ -> NoPieceToMove
end

