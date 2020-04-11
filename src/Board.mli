module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type square =
    | Occupied: position * piece -> square
    | Empty   : position -> square

  type turn =
    | NoPieceToMove
    | OccupiedDestination

  val square: position -> square
  val move  : piece -> square -> turn
  val play  : (piece * position) list -> turn
end
