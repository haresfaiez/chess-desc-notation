open Jest
open Expect

open Board

let () =
  describe "Initial board" (fun () ->
      test "puts the white king in K1" (fun () ->
          expect (Board.occupant Board.King 1) |> toBe (Some Board.King));
      test "puts the white queen in Q1" (fun () ->
          expect (Board.occupant Board.Queen 1) |> toBe (Some Board.Queen));
      test "puts no piece in K3" (fun () ->
          expect (Board.occupant Board.King 3) |> toBe None);
    );
