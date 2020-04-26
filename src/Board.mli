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

  type movement = piece * position * position

  val move    : piece -> position -> turn
  val turn    : piece -> position -> turn
  val play    : (piece * position) list -> turn
  val playTurn: piece -> position -> movement list -> turn
  val forward : piece -> piece -> int -> movement
end
