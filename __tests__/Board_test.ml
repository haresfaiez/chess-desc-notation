open Jest
open Expect

open Board

let k rank           : Board.position = (Board.King, (Board.Rank rank))
let q rank           : Board.position = (Board.Queen, (Board.Rank rank))
let kn rank          : Board.position = (Board.Knight, (Board.Rank rank))
let moveP from count : Board.movement = Board.shiftRank Board.Pawn from count
let moveQ from count : Board.movement = Board.shiftRank Board.Queen from count

let () =
  describe "Initial movement: P" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board.move Board.Pawn (k 7)) |> toBe Board.Unreachable);
      test "-K3 succeeds" (fun () ->
          expect (Board.move Board.Pawn (k 3)) |> toBe Board.End);
      test "-Q3 suuceeds" (fun () ->
          expect (Board.move Board.Pawn (q 3)) |> toBe Board.End);
    );
  describe "Movement: P" (fun () ->
      test "-K7 is unreachable from K2" (fun () ->
          expect (Board._move Board.Pawn [(k 2)] (k 7)) |> toBe Board.Unreachable);
      test "-K3 succeeds from K2" (fun () ->
          expect (Board._move Board.Pawn [(k 2)] (k 3)) |> toEqual (Board.Moved (moveP (k 2) 1)));
    );
  describe "Initial movement: K" (fun () ->
      test "-K3 fails" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
      test "-K3 is unreachable" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board.turn Board.Knight (k 7) []) |> toBe Board.Unreachable);
    );
  describe "Initial movement: Q" (fun () ->
      test "-Q1 succeeds" (fun () ->
        expect (Board.move Board.Queen (q 1)) |> toBe Board.End);
      test "-Q2 succeeds" (fun () ->
        expect (Board.move Board.Queen (q 2)) |> toBe Board.End);
    );
  describe "Movement: Q" (fun () ->
      test "-Q4 succeeds from Q1" (fun () ->
        expect (Board._move Board.Queen [(q 1)] (q 4)) |> toEqual (Board.Moved (moveQ (q 1) 3)));
    );
  describe "PlayTurn" (fun () ->
      test "detects no conflicts in [P-K3, P-Q3]" (fun () ->
        expect (Board.turn Board.Pawn (q 3) [(moveP (k 2) 1)]) |> toEqual (Board.Moved (moveP (q 3) 0)));
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (Board.turn Board.Queen (q 3) [(moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects a conflict in [P-Q3, P-K3, Q-Q3]" (fun () ->
        expect (Board.turn Board.Queen (q 3) [(moveP (k 2) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [P-K3]" (fun () ->
        expect (Board.turn Board.Pawn (k 3) []) |> toEqual (Board.Moved (moveP (k 3) 0)));
      test "detects a conflict at Q-Q4 in [P-Q3, P-Q4, Q-Q4]" (fun () ->
        expect (Board.turn Board.Queen (q 4) [(moveP (q 3) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [Q-Q2, Q-Q1, Q-Q2, Q-Q1]" (fun () ->
        expect (Board.turn Board.Queen (q 1) [(moveQ (q 1) 1); (moveQ (q 2) (-1))]) |> toEqual (Board.Moved (moveQ (q 1) 0)));
      test "detects unreachable destination in [P-Kn3, Kn-Kn2]" (fun () ->
        expect (Board.turn Board.Knight (kn 2) [moveP (kn 2) 1]) |> toBe Board.Unreachable);
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
          expect(moveP (k 2) 1) |> toEqual (Board.Pawn, (k 2), (k 3)));
      test "keeps pawn in K2 when the steps count is 0" (fun () ->
          expect(moveP (k 2) 0) |> toEqual (Board.Pawn, (k 2), (k 2)));
      test "moves queen one step forward" (fun() ->
          expect(moveQ (q 2) 1) |> toEqual (Board.Queen, (q 2), (q 3)));
      test "moves queen one step backward" (fun() ->
          expect(moveQ (q 2) (-1)) |> toEqual (Board.Queen, (q 2), (q 1)));
    );
