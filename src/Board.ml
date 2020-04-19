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

  let turn piece position =
    match occupant position with
    | Some piece -> Conflict
    | None       -> move piece position

  let playTurn piece position next =
    match next with
    | []             -> Moved
    | (_, next) :: _ -> (match position = next with
                         | true  -> Conflict
                         | false -> Moved)
    | _              -> Moved

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> let turnOutcome = turn piece position in
                                match turnOutcome with
                                | Moved -> play (List.tl moves)
                                | _     -> turnOutcome
end
