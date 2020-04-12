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
    | Unreachable
    | Conflict
    | Moved
    | Removed: position -> turn

  val get  : position -> turn
  val move : piece -> position -> turn
  val turn : piece -> square -> turn
  val _turn: piece -> turn -> turn
  val play : (piece * position) list -> turn
end
