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

  val move    : piece -> position -> turn
  val turn    : piece -> position -> turn
  val play    : (piece * position) list -> turn
  val playTurn: piece -> position -> (piece * position) list -> turn
  val conflicts: position -> (position * position) -> turn option
end
