module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type movement = piece * position * position

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  val move     : piece -> position list -> position -> turn
  val play     : (piece * position) list -> movement list -> turn
  val turn     : piece -> position -> movement list -> turn
  val init     : position -> movement list
  val setup    : piece -> position list
  val shiftRank: piece -> position -> int -> movement
end
