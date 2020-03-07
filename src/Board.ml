module Board = struct
  type piece =
    | King
    | Queen

  let occupant file rank =
    match rank with
    | 1 -> Some file
    | _ -> None
end

