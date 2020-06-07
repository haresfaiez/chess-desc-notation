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
    | (file, Rank 1) -> [(file, List.hd (setup file), (square, []))]
    | (_, Rank 2)    -> [(Pawn, (square, []), (square, []))] (* TODO: Use setup *)
    | _              -> []

  let rec moveOptions sources destination =
    let check ((source, options), destination) next = (* TODO: set destination options *)
      if (List.exists (fun e -> e = destination) options)
      then [Moved ((source, options), (destination, []))]
      else if (source = (Queen, Rank 1)) (* TODO: Remove this *)
      then [Moved ((source, options), (destination, []))]
      else moveOptions next destination
    in
    match sources with
    | []             -> [Unreachable]
    | source :: next -> check (source, destination) next

  (* Implement a strategy to select the option *)
  let move sources destination = List.hd (moveOptions sources destination)

  let rec turn piece destination history = (* TODO: replace piece with sources *)
    let sources = setup piece in
    match history with
    | []                                           -> move sources destination
    | (_, _, (dst, _)) :: _ when destination = dst -> Conflict
    | (_, (src, _), _) :: _ when destination = src -> move sources destination
    | _                                            -> turn piece destination (List.tl history)

  let rec play moves history =
    match moves with
    | []                       -> End
    | (piece, nextSquare) :: _ -> let outcome = turn piece nextSquare (List.append history (init nextSquare)) in
                                  match outcome with
                                  | Moved (s, d) -> play (List.tl moves) ((piece, s, d) :: history)
                                  | _               -> outcome

  let start moves = play moves []

end
