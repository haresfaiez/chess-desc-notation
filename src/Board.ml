module Board = struct
  type piece =
    | King
    | Queen
  let pieceAt file b =
    match file with
    | 'K' -> King
    | 'Q' -> Queen
end

