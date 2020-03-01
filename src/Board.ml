module Board = struct
  type piece =
    | King
    | Queen
  let pieceAt a b =
    match a with
    | 'K' -> King
    | 'Q' -> Queen
end

