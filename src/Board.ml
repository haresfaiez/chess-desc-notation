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

  let move (subject : piece) ((position, occupant) : square) : moveFailure =
    match position with
    | (toFile, (Rank toRank)) -> match occupant with
                                 | Some piece -> OccupiedDestination
                                 | None       -> match toRank with
                                                 | _ -> NoPieceToMove

  let _move piece destination =
    match destination with
    | (Occupied (position, piece)) -> OccupiedDestination
    | (Empty position)             -> (move piece (position, None))
end

