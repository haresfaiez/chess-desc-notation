module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type position = (piece * rank)

  type turn =
    | Unreachable
    | Conflict
    | Moved
    | Removed: position -> turn

  let occupant (file, Rank rank) =
    match rank with
    | 1 -> Some file
    | 2 -> Some Pawn
    | _ -> None

  let move piece destination =
    match destination with
    | (_, (Rank 3)) -> (match piece with
                          | King -> Unreachable
                          | Pawn -> Moved)
    | _             -> Unreachable

  let get position =
    match (occupant position) with
    | Some piece -> Conflict
    | None       -> Removed position

  let turn piece position =
    let destination = get position in
    match destination with
    | Conflict  -> (match (occupant position) with
                    | Some piece -> Conflict)
    | Moved     -> (match (occupant position) with
                    | Some piece -> Conflict)
    | Removed _ -> (match (occupant position) with
                    | None -> move piece position)

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> let destination = turn piece position in
                                match destination with
                                | Moved -> play (List.tl moves)
                                | _     -> destination
end
