open Jest
open Expect

open Board

let shift (file, Board.Rank origin) steps = (file, Board.Rank (origin + steps))
let shiftRank piece source steps = (piece, source, shift source steps)
let k rank                = (Board.King, (Board.Rank rank))
let q rank                = (Board.Queen, (Board.Rank rank))
let kn rank               = (Board.Knight, (Board.Rank rank))
let movementP from count  = shiftRank Board.Pawn from count
let movementQ from count  = shiftRank Board.Queen from count
let sMovementQ from count = (Board.Queen, (from, []), shift from count)
let sMovementP from count = (Board.Pawn, (from, []), shift from count)
let source position       = (position, [])
let destination actual    = match actual with | Board.Moved (_, _, result) -> result

let () =
  describe "Initial piece positions" (fun () ->
      test "of the king are K1" (fun () ->
          expect (Board.setup Board.King) |> toEqual [((k 1), [(k 2)])]);
      test "of the Queen are Q1" (fun () ->
          expect (Board.setup Board.Queen) |> toEqual [(q 1), [(q 2); (q 3); (q 4)]]);
      test "of the Knight are Kn1,Kn1" (fun () ->
          expect (Board.setup Board.Knight) |> toEqual [(kn 1, []); (kn 1, [])]);
      test "of the pawn are Kn2,K2,Q2,Kn2" (fun () ->
          expect (Board.setup Board.Pawn) |> toEqual [(kn 2, [(kn 3)]); (q 2, [(q 3)]); (k 2, [(k 3)]); (kn 2, [(kn 3)])]);
    );
  describe "Movement" (fun () ->
      test "fails when no sources are available" (fun () ->
        expect (Board.move Board.Pawn [] (k 3)) |> toBe Board.Unreachable);
    );
  describe "Movement: P" (fun () ->
      test "-K7 is unreachable from K2" (fun () ->
          expect (Board.move Board.Pawn [source (k 2)] (k 7)) |> toBe Board.Unreachable);
      test "-K3 succeeds from K2" (fun () ->
          expect (destination (Board.move Board.Pawn [(k 2), [(k 3)]] (k 3))) |> toEqual (k 3));
      test "-K3 succeeds from initial setup" (fun () ->
          expect (Board.moveOptions Board.Pawn (Board.setup Board.Pawn) (k 3)) |> toEqual [Board.Moved (sMovementP (k 2) 1)]);
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board.turn Board.Knight (k 7) []) |> toBe Board.Unreachable);
    );
  describe "Movement: K" (fun () ->
      test "-K3 is unreachable from K1" (fun () ->
          expect (Board.move Board.King [source (k 1)] (k 3)) |> toBe Board.Unreachable);
    );
  describe "Movement: Q" (fun () ->
      test "-Q4 succeeds from Q1" (fun () ->
        expect (destination (Board.move Board.Queen [source (q 1)] (q 4))) |> toEqual (q 4));
    );
  describe "PlayTurn" (fun () ->
      test "detects no conflicts in [P-K3, P-Q3]" (fun () ->
        expect (destination (Board.turn Board.Pawn (q 3) [(movementP (k 2) 1)])) |> toEqual (q 3));
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (Board.turn Board.Queen (q 3) [(movementP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects a conflict in [P-Q3, P-K3, Q-Q3]" (fun () ->
        expect (Board.turn Board.Queen (q 3) [(movementP (k 2) 1); (movementP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [P-K3]" (fun () ->
        expect (Board.turn Board.Pawn (k 3) []) |> toEqual (Board.Moved (sMovementP (k 2) 1)));
      test "detects a conflict at Q-Q4 in [P-Q3, P-Q4, Q-Q4]" (fun () ->
        expect (Board.turn Board.Queen (q 4) [(movementP (q 3) 1); (movementP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [Q-Q2, Q-Q1, Q-Q2, Q-Q1]" (fun () ->
        expect (Board.turn Board.Queen (q 1) [(movementQ (q 1) 1); (movementQ (q 2) (-1))])
        |> toEqual (Board.Moved (sMovementQ (q 1) 0)));
      test "detects unreachable destination in [P-Kn3, Kn-Kn2]" (fun () ->
        expect (Board.turn Board.Knight (kn 2) [movementP (kn 2) 1]) |> toBe Board.Unreachable);
    );
  describe "Game play" (fun () ->
      test "[K-K2] fails" (fun () ->
          expect (Board.play [(Board.King, (k 2))] []) |> toBe Board.Conflict);
      test "[K-K2, P-Q3] fails" (fun () ->
          expect (Board.play [(Board.King, (k 2)); (Board.Pawn, (q 3))] []) |> toBe Board.Conflict);
      test "[P-K7, P-Q3] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (k 7)); (Board.Pawn, (q 3))] []) |> toBe Board.Unreachable);
      test "[P-Q3, K-K2] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.King, (k 2))] []) |> toBe Board.Conflict);
      test "[P-Q3, Q-Q3] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.Queen, (q 3))] []) |> toBe Board.Conflict);
      test "[P-Q3, P-K3, Q-Q3] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.Pawn, (k 3)); (Board.Queen, (q 3))] []) |> toBe Board.Conflict);
      test "[P-Q3, Q-Q2] succeeds" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.Queen, (q 2))] []) |> toBe Board.End);
    );
  describe "Vertical movement" (fun () ->
      test "moves pawn from P-K2 to P-K3" (fun () ->
          expect(movementP (k 2) 1) |> toEqual (Board.Pawn, (k 2), (k 3)));
      test "keeps pawn in K2 when the steps count is 0" (fun () ->
          expect(movementP (k 2) 0) |> toEqual (Board.Pawn, (k 2), (k 2)));
      test "moves queen one step forward" (fun() ->
          expect(movementQ (q 2) 1) |> toEqual (Board.Queen, (q 2), (q 3)));
      test "moves queen one step backward" (fun() ->
          expect(movementQ (q 2) (-1)) |> toEqual (Board.Queen, (q 2), (q 1)));
    );
