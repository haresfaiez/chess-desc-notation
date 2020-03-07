module Board : sig
  type piece =
    | King
    | Queen
  val occupant: piece -> int -> piece option
end
