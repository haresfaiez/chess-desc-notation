module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type turn =
    | Unreachable
    | Conflict
    | Moved
    | Removed: position -> turn

  val move: piece -> position -> turn
  val turn: piece -> position -> turn
  val play: (piece * position) list -> turn
end
