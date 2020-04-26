open Jest
open Expect

open Board

let k rank           : Board.position = (Board.King, (Board.Rank rank))
let q rank           : Board.position = (Board.Queen, (Board.Rank rank))
let moveP from count : Board.movement = Board.vertical Board.Pawn from count

let () =
  describe "Initial movement: P" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board.turn Board.Pawn (k 7)) |> toBe Board.Unreachable);
      test "-K1 fails" (fun () ->
          expect (Board.turn Board.Pawn (k 1)) |> toBe Board.Conflict);
      test "-K3 succeeds" (fun () ->
          expect (Board.turn Board.Pawn (k 3)) |> toBe Board.Moved);
      test "-Q3 suuceeds" (fun () ->
          expect (Board.move Board.Pawn (q 3)) |> toBe Board.Moved);
    );
  describe "Initial movement: K" (fun () ->
      test "-K2 creates conflict" (fun () ->
          expect (Board.turn Board.King (k 2)) |> toBe Board.Conflict);
      test "-K3 fails" (fun () ->
          expect (Board.turn Board.King (k 3)) |> toBe Board.Unreachable);
      test "-K3 is unreachable" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board.turn Board.Knight (k 7)) |> toBe Board.Unreachable);
    );
  describe "PlayTurn" (fun () ->
      test "detects no conflicts in [P-K3, P-Q3]" (fun () ->
        expect (Board.playTurn Board.Pawn (q 3) [(moveP (k 2) 1)]) |> toBe Board.Moved);
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (Board.playTurn Board.Queen (q 3) [(moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects a conflict in [P-Q3, P-K3, Q-Q3]" (fun () ->
        expect (Board.playTurn Board.Queen (q 3) [(moveP (k 2) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [P-K3]" (fun () ->
        expect (Board.playTurn Board.Pawn (k 3) []) |> toBe Board.Moved);
      test "detects a conflict at Q-Q4 in [P-Q3, P-Q4, Q-Q4]" (fun() ->
        expect (Board.playTurn Board.Queen (q 4) [(moveP (q 3) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
    );
  describe "Game play" (fun () ->
      test "[K-K2] fails" (fun () ->
          expect (Board.play [(Board.King, (k 2))]) |> toBe Board.Conflict);
      test "[K-K2, P-Q3] fails" (fun () ->
          expect (Board.play [(Board.King, (k 2)); (Board.Pawn, (q 3))]) |> toBe Board.Conflict);
      test "[P-K7, P-Q3] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (k 7)); (Board.Pawn, (q 3))]) |> toBe Board.Unreachable);
      test "[P-Q3, K-K2] fails" (fun () ->
          expect (Board.play [(Board.Pawn, (q 3)); (Board.King, (k 2))]) |> toBe Board.Conflict);
    );
  describe "Vertical movement" (fun () ->
      test "moves pawn from P-K2 to P-K3" (fun () ->
          expect(moveP (k 2) 1) |> toEqual (Board.Pawn, (k 2), (k 3)));
      test "keeps pawn in K2 when the steps count is 0" (fun () ->
          expect(moveP (k 2) 0) |> toEqual (Board.Pawn, (k 2), (k 2)));
      test "moves queen one step forward" (fun() ->
          expect(Board.vertical Board.Queen (q 2) 1) |> toEqual (Board.Queen, (q 2), (q 3)));
      test "moves queen one step backward" (fun() ->
          expect(Board.vertical Board.Queen (q 2) (-1)) |> toEqual (Board.Queen, (q 2), (q 1)));
    );
