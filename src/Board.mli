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
    | Occupied: square -> _square

  type moveFailure =
    | NoPieceToMove
    | OccupiedDestination

  val occupant: position -> square
  val move    : piece -> square -> moveFailure
  val _move   : piece -> _square -> moveFailure
end
