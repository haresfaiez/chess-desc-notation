open List

module Board = struct
  (* TODO: Pawn cannot be a position *)
  type piece =
    | King
    | Queen
    | Knight
    | Pawn

  type rank =
    | Rank of int (* value should be between 1 and 8 *)

  type square = piece * rank

  type position = square * square list

  type movement = position * position

  type history = (piece * position * position) list

  type turn =
    | Unreachable
    | Conflict
    | Moved: movement -> turn
    | End

  type setup = piece -> position list

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
    let findDestinationIn (_, options) = exists (fun e -> e = destination) options in
    match sources with
    | []                                               -> [Unreachable] (* TODO: Add variant for null-movement *)
    | current :: next when (findDestinationIn current) -> [Moved (current, (destination, []))] (* TODO: Set destination options *)
    | _ :: next                                        -> moveOptions next destination

  (* Implement a strategy to select the option *)
  let move sources destination = hd (moveOptions sources destination)

  let rec turn sources destination history =
    match history with
    | []                                           -> move sources destination
    | (_, _, (dst, _)) :: _ when destination = dst -> Conflict
    | (_, (src, _), _) :: _ when destination = src -> move sources destination
    | _                                            -> turn sources destination (tl history)

  (* TODO: Use nextSetup *)
  let rec play moves history =
    match moves with
    | []                        -> End
    | (piece, destination) :: _ -> let _setup = if ((piece = Pawn) && (destination = (Queen, (Rank 4))))
                                               then [((Queen, Rank 3), [(Queen, Rank 4)])]
                                               else (setup piece) in
                                   let outcome = turn _setup destination (append history (init destination)) in
                                   match outcome with
                                   | Moved (from, _to) -> play (tl moves) ((piece, from, _to) :: history)
                                   | _                 -> outcome

  let start moves = play moves []

  let nextSetup setup expected (source, destination) =
    fun actual ->
    if (expected = actual)
    then (destination :: (filter (fun e -> e <> source) (setup expected)))
    else (setup actual)

end
