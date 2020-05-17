module Board : sig
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int

  type position = (piece * rank)

  type source = position * position list

  type movement = piece * position * position

  type turn =
    | Unreachable
    | Conflict
    | SMoved: (piece * source * position) -> turn
    | End

  val moveOptions  : piece -> source list -> position -> turn list
  val move         : piece -> source list -> position -> turn
  val play         : (piece * position) list -> movement list -> turn
  val turn         : piece -> position -> movement list -> turn
  val init         : position -> movement list
  val setup        : piece -> source list
end
