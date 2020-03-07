module Board : sig
  type piece =
    | King
    | Queen
  val at     : piece -> int -> piece option
end
