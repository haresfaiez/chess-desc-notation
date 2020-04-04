module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type square = (position * (piece option))

  type _square =
    | Occupied: position * piece -> _square
    | Empty   : position -> _square

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  val occupant: position -> square
  val _move   : piece -> _square -> moveFailure
end
