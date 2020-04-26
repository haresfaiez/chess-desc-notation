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

  type movement = piece * position * position

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

  (* use source *)
  let rec playTurn piece position history =
    let checkConflict (_, source, destination) =
      if position = source
      then playTurn piece position []
      else if position = destination
      then Conflict
      else (playTurn piece position (List.tl history))
    in

    match history with
    | []        -> Moved
    | prev :: _ -> checkConflict prev

  let rec play moves =
    match moves with
    | []                     -> Moved
    | (piece, position) :: _ -> let turnOutcome = turn piece position in
                                match turnOutcome with
                                | Moved -> play (List.tl moves)
                                | _     -> turnOutcome

  let vertical piece (file, Rank origin) steps = (piece, (file, Rank origin), (file, Rank (origin + steps)))
end
