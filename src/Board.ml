open List

module Board = struct
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type square = (piece * rank)

  type position = square * square list

  type movement = position * position

  type history = (piece * position * position) list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  let setup piece =
    let at rank = (piece, Rank rank) in
    let pawnAt file = ((file, Rank 2), [(file, Rank 3)]) in
    match piece with
    | King   -> [(at 1, [(at 2)])]
    | Queen  -> [(at 1, [(at 2); (at 3); (at 4)])]
    | Pawn   -> [(pawnAt Knight); (pawnAt Queen); (pawnAt King); (pawnAt Knight)]
    | _      -> [((piece, Rank 1), []); ((piece, Rank 1), [])]

  let init square =
    match square with
    | (file, Rank 1) -> [(file, hd (setup file), (square, []))]
    | (_, Rank 2)    -> [(Pawn, (square, []), (square, []))] (* TODO: Use setup *)
    | _              -> []

  let rec moveOptions sources destination =
    let findDestination (_, options) = exists (fun e -> e = destination) options in
    match sources with
    | []                        -> [Unreachable]
    | (source, options) :: next when (findDestination (source, options)) -> [Moved ((source, options), (destination, []))]
    | _ :: next -> moveOptions next destination

  (* Implement a strategy to select the option *)
  let move sources destination = hd (moveOptions sources destination)

  let rec turn sources destination history =
    match history with
    | []                                           -> move sources destination
    | (_, _, (dst, _)) :: _ when destination = dst -> Conflict
    | (_, (src, _), _) :: _ when destination = src -> move sources destination
    | _                                            -> turn sources destination (tl history)

  let rec play moves history =
    match moves with
    | []                       -> End
    | (piece, nextSquare) :: _ -> let outcome = turn (setup piece) nextSquare (append history (init nextSquare)) in
                                  match outcome with
                                  | Moved (sorce, destination) -> play (tl moves) ((piece, sorce, destination) :: history)
                                  | _                          -> outcome

  let start moves = play moves []

end
