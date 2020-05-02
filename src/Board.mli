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

  val move     : piece -> position -> turn
  val play     : (piece * position) list -> movement list -> turn
  val turn     : piece -> position -> movement list -> turn
  val shiftRank: piece -> position -> int -> movement
end
