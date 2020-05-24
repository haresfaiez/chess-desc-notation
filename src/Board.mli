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
  type _movement = piece * source * position

  type history = movement list
  type _history = _movement list

  type turn =
    | Unreachable
    | Conflict
    | Moved: _movement -> turn
    | End

  val moveOptions  : piece -> source list -> position -> turn list
  val move         : piece -> source list -> position -> turn
  val play         : (piece * position) list -> _history -> turn
  val turn         : piece -> position -> _history -> turn
  val _init        : position -> _history
  val setup        : piece -> source list
end
