open Jest
open Expect

open Board

let k rank : Board.position = (Board.King, (Board.Rank rank))
let q rank : Board.position = (Board.Queen, (Board.Rank rank))

let () =
  describe "Initial board" (fun () ->
      test "moves the white king to K1" (fun () ->
          expect (Board.get (k 1)) |> toEqual Board.Moved);
      test "moves the white queen to Q1" (fun () ->
          expect (Board.get (q 1)) |> toEqual Board.Moved);
      test "removes all pieces from K3" (fun () ->
          expect (Board.get (k 3)) |> toEqual (Board.Removed (k 3)));
      test "removes all pieces from Q5" (fun () ->
          expect (Board.get (q 5)) |> toEqual (Board.Removed (q 5)));
      test "removes all pieces from the third rank" (fun () ->
          expect (Board.get (k 3)) |> toEqual (Board.Removed (k 3)));
    );
  describe "Initial movement: P" (fun () ->
      test "-K7 fails" (fun () ->
          expect (Board._turn Board.Pawn (k 7)) |> toBe Board.Unreachable);
      test "-K1 fails" (fun () ->
          expect (Board._turn Board.Pawn (k 1)) |> toBe Board.Conflict);
      test "-K3 succeeds" (fun () ->
          expect (Board._turn Board.Pawn (k 3)) |> toBe Board.Moved);
      test "-Q3 suuceeds" (fun () ->
          expect (Board.move Board.Pawn (q 3)) |> toBe Board.Moved);
    );
  describe "Initial movement: K" (fun () ->
      test "-K2 creates conflict" (fun () ->
          expect (Board._turn Board.King (k 2)) |> toBe Board.Conflict);
      test "-K3 fails" (fun () ->
          expect (Board._turn Board.King (k 3)) |> toBe Board.Unreachable);
      test "-K3 is unreachable" (fun () ->
          expect (Board.move Board.King (k 3)) |> toBe Board.Unreachable);
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 is unreachable" (fun () ->
          expect (Board.turn Board.Knight (Board.Removed (k 7))) |> toBe Board.Unreachable);
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
