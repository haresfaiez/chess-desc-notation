open Jest
open Expect
open Board.Board

let shift (file, Rank origin) steps = (file, Rank (origin + steps))

let k rank           = (King, (Rank rank))
let q rank           = (Queen, (Rank rank))
let kn rank          = (Knight, (Rank rank))
let moveP from steps = (Pawn, (from, []), (shift from steps, []))
let moveQ from steps = (Queen, (from, []), (shift from steps, []))

let destination actual = match actual with | Moved (_, (result, _)) -> result

let initTurn piece destination history = turn (setup piece) destination history

let () =
  describe "Initial piece positions" (fun () ->
      test "of the king are K1" (fun () ->
          expect (setup King) |> toEqual [(k 1, [k 2])]);
      test "of the Queen are Q1" (fun () ->
          expect (setup Queen) |> toEqual [q 1, [q 2; q 3; q 4]]);
      test "of the Knight are Kn1,Kn1" (fun () ->
          expect (setup Knight) |> toEqual [(kn 1, []); (kn 1, [])]);
      test "of the pawn are Kn2,K2,Q2,Kn2" (fun () ->
          expect (setup Pawn) |> toEqual [(kn 2, [(kn 3)]); (q 2, [q 3]); (k 2, [k 3]); (kn 2, [kn 3])]);
    );
  describe "Movement" (fun () ->
      test "fails when no sources are available" (fun () ->
        expect (move [] (k 3)) |> toBe Unreachable);
    );
  describe "Movement: P" (fun () ->
      test "-K7 is unreachable from K2" (fun () ->
          expect (move [(k 2, [])] (k 7)) |> toBe Unreachable);
      test "-K3 succeeds from K2" (fun () ->
          expect (destination (move [k 2, [k 3]] (k 3))) |> toEqual (k 3));
      test "-K3 succeeds from initial setup" (fun () ->
          expect (move (setup Pawn) (k 3)) |> toEqual (Moved ((k 2, [k 3]), (shift (k 2) 1, []))));
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 fails" (fun () ->
          expect (initTurn Knight (k 7) []) |> toBe Unreachable);
    );
  describe "Movement: K" (fun () ->
      test "-K3 is unreachable from K1" (fun () ->
          expect (move [(k 1, [])] (k 3)) |> toBe Unreachable);
      test "-K7 is unreachable from K2" (fun () ->
          expect (initTurn King (k 3) [(King, (k 1, []), (k 2, []))]) |> toBe Unreachable);
    );
  describe "Movement: Q" (fun () ->
      test "-Q4 succeeds from Q1" (fun () ->
        expect (destination (move (setup Queen) (q 4))) |> toEqual (q 4));
    );
  describe "PlayTurn" (fun () ->
      test "detects no conflicts in [P-K3, P-Q3]" (fun () ->
        expect (destination (initTurn Pawn (q 3) [(moveP (k 2) 1)])) |> toEqual (q 3));
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (initTurn Queen (q 3) [(moveP (q 2) 1)]) |> toBe Conflict);
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (initTurn Queen (q 3) [moveP (q 2) 1]) |> toBe Conflict);
      test "detects a conflict in [P-Q3, P-K3, Q-Q3]" (fun () ->
        expect (initTurn Queen (q 3) [(moveP (k 2) 1); (moveP (q 2) 1)]) |> toBe Conflict);
      test "detects no conflicts in [P-K3]" (fun () ->
        expect (destination (initTurn Pawn (k 3) [])) |> toEqual (k 3));
      test "detects a conflict at Q-Q4 in [P-Q3, P-Q4, Q-Q4]" (fun () ->
        expect (initTurn Queen (q 4) [(moveP (q 3) 1); (moveP (q 2) 1)]) |> toBe Conflict);
      test "detects an unreachable movement in [Q-Q1, Q-Q1]" (fun () ->
        expect (initTurn Queen (q 1) [(moveQ (q 1) 1)]) |> toBe Unreachable);
      test "detects unreachable destination in [P-Kn3, Kn-Kn2]" (fun () ->
        expect (initTurn Knight (kn 2) [moveP (kn 2) 1]) |> toBe Unreachable);
    );
  describe "Game play" (fun () ->
      test "[K-K2] fails" (fun () ->
          expect (start [(King, k 2)]) |> toBe Conflict);
      test "[K-K2, P-Q3] fails" (fun () ->
          expect (start [(King, k 2); (Pawn, q 3)]) |> toBe Conflict);
      test "[P-K7, P-Q3] fails" (fun () ->
          expect (start [(Pawn, (k 7)); (Pawn, q 3)]) |> toBe Unreachable);
      test "[P-Q3, K-K2] fails" (fun () ->
          expect (start [(Pawn, q 3); (King, k 2)]) |> toBe Conflict);
      test "[P-Q3, Q-Q3] fails" (fun () ->
          expect (start [(Pawn, q 3); (Queen, q 3)]) |> toBe Conflict);
      test "[P-Q3, P-K3, Q-Q3] fails" (fun () ->
          expect (start [(Pawn, q 3); (Pawn, k 3); (Queen, q 3)]) |> toBe Conflict);
      test "[P-Q3, Q-Q2] succeeds" (fun () ->
          expect (start [(Pawn, q 3); (Queen, q 2)]) |> toBe End);
    );
  describe "Vertical movement" (fun () ->
      test "moves pawn from P-K2 to P-K3" (fun () ->
          expect(moveP (k 2) 1) |> toEqual (Pawn, (k 2, []), (k 3, [])));
      test "keeps pawn in K2 when the steps count is 0" (fun () ->
          expect(moveP (k 2) 0) |> toEqual (Pawn, (k 2, []), (k 2, [])));
      test "moves queen one step forward" (fun() ->
          expect(moveQ (q 2) 1) |> toEqual (Queen, (q 2, []), (q 3, [])));
      test "moves queen one step backward" (fun() ->
          expect(moveQ (q 2) (-1)) |> toEqual (Queen, (q 2, []), (q 1, [])));
    );
  describe "Next setup" (fun () ->
      let pQ2 = (q 2, [q 3]) in
      let pQ3 = (q 3, [q 4]) in
      let pQ2Q3 = (pQ2, pQ3) in
      test "overrides inital pawn setup after it moves" (fun () ->
          expect((nextSetup (fun _ -> [q 2, [q 3]]) Pawn pQ2Q3) Pawn) |> toEqual [q 3, [q 4]]);
      test "returns inital queen setup when it does not move" (fun () ->
          expect((nextSetup (fun _ -> [q 1, []]) Pawn pQ2Q3) Queen) |> toEqual [q 1, []]);
      test "keeps non-moved pawns when a pawn moves" (fun () ->
          expect((nextSetup (fun _ -> [pQ2; (k 2, [k 3])]) Pawn pQ2Q3) Pawn) |> toEqual [pQ3; (k 2, [k 3])]);
    );
