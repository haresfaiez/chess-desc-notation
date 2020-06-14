open Jest
open Expect

open Board

let shift (file, Board.Rank origin) steps = (file, Board.Rank (origin + steps))

let k rank           = (Board.King, (Board.Rank rank))
let q rank           = (Board.Queen, (Board.Rank rank))
let kn rank          = (Board.Knight, (Board.Rank rank))
let toPos square     = (square, [])
let moveP from steps = (Board.Pawn, toPos from, toPos (shift from steps))
let moveQ from steps = (Board.Queen, toPos from, toPos (shift from steps))

let destination actual = match actual with | Board.Moved (_, (result, _)) -> result

let initTurn piece destination history = Board.turn (Board.setup piece) destination history

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
        expect (Board.move [] (k 3)) |> toBe Board.Unreachable);
    );
  describe "Movement: P" (fun () ->
      test "-K7 is unreachable from K2" (fun () ->
          expect (Board.move [toPos (k 2)] (k 7)) |> toBe Board.Unreachable);
      test "-K3 succeeds from K2" (fun () ->
          expect (destination (Board.move [(k 2), [(k 3)]] (k 3))) |> toEqual (k 3));
      test "-K3 succeeds from initial setup" (fun () ->
          expect (Board.move (Board.setup Board.Pawn) (k 3)) |> toEqual (Board.Moved (((k 2), [(k 3)]), (shift (k 2) 1, []))));
    );
  describe "Initial movement: Kn" (fun () ->
      test "-K7 fails" (fun () ->
          expect (initTurn Board.Knight (k 7) []) |> toBe Board.Unreachable);
    );
  describe "Movement: K" (fun () ->
      test "-K3 is unreachable from K1" (fun () ->
          expect (Board.move [toPos (k 1)] (k 3)) |> toBe Board.Unreachable);
      test "-K7 is unreachable from K2" (fun () ->
          expect (initTurn Board.King (k 3) [(Board.King, (toPos (k 1)), (toPos (k 2)))]) |> toBe Board.Unreachable);
    );
  describe "Movement: Q" (fun () ->
      test "-Q4 succeeds from Q1" (fun () ->
        expect (destination (Board.move (Board.setup Board.Queen) (q 4))) |> toEqual (q 4));
    );
  describe "PlayTurn" (fun () ->
      test "detects no conflicts in [P-K3, P-Q3]" (fun () ->
        expect (destination (initTurn Board.Pawn (q 3) [(moveP (k 2) 1)])) |> toEqual (q 3));
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (initTurn Board.Queen (q 3) [(moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects a conflict in [P-Q3, Q-Q3]" (fun () ->
        expect (initTurn Board.Queen (q 3) [moveP (q 2) 1]) |> toBe Board.Conflict);
      test "detects a conflict in [P-Q3, P-K3, Q-Q3]" (fun () ->
        expect (initTurn Board.Queen (q 3) [(moveP (k 2) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects no conflicts in [P-K3]" (fun () ->
        expect (destination (initTurn Board.Pawn (k 3) [])) |> toEqual (k 3));
      test "detects a conflict at Q-Q4 in [P-Q3, P-Q4, Q-Q4]" (fun () ->
        expect (initTurn Board.Queen (q 4) [(moveP (q 3) 1); (moveP (q 2) 1)]) |> toBe Board.Conflict);
      test "detects an unreachable movement in [Q-Q1, Q-Q1]" (fun () ->
        expect (initTurn Board.Queen (q 1) [(moveQ (q 1) 1)]) |> toBe Board.Unreachable);
      test "detects unreachable destination in [P-Kn3, Kn-Kn2]" (fun () ->
        expect (initTurn Board.Knight (kn 2) [moveP (kn 2) 1]) |> toBe Board.Unreachable);
    );
  describe "Game play" (fun () ->
      test "[K-K2] fails" (fun () ->
          expect (Board.start [(Board.King, (k 2))]) |> toBe Board.Conflict);
      test "[K-K2, P-Q3] fails" (fun () ->
          expect (Board.start [(Board.King, (k 2)); (Board.Pawn, (q 3))]) |> toBe Board.Conflict);
      test "[P-K7, P-Q3] fails" (fun () ->
          expect (Board.start [(Board.Pawn, (k 7)); (Board.Pawn, (q 3))]) |> toBe Board.Unreachable);
      test "[P-Q3, K-K2] fails" (fun () ->
          expect (Board.start [(Board.Pawn, (q 3)); (Board.King, (k 2))]) |> toBe Board.Conflict);
      test "[P-Q3, Q-Q3] fails" (fun () ->
          expect (Board.start [(Board.Pawn, (q 3)); (Board.Queen, (q 3))]) |> toBe Board.Conflict);
      test "[P-Q3, P-K3, Q-Q3] fails" (fun () ->
          expect (Board.start [(Board.Pawn, (q 3)); (Board.Pawn, (k 3)); (Board.Queen, (q 3))]) |> toBe Board.Conflict);
      test "[P-Q3, Q-Q2] succeeds" (fun () ->
          expect (Board.start [(Board.Pawn, (q 3)); (Board.Queen, (q 2))]) |> toBe Board.End);
    );
  describe "Vertical movement" (fun () ->
      test "moves pawn from P-K2 to P-K3" (fun () ->
          expect(moveP (k 2) 1) |> toEqual (Board.Pawn, ((k 2), []), ((k 3), [])));
      test "keeps pawn in K2 when the steps count is 0" (fun () ->
          expect(moveP (k 2) 0) |> toEqual (Board.Pawn, ((k 2), []), ((k 2), [])));
      test "moves queen one step forward" (fun() ->
          expect(moveQ (q 2) 1) |> toEqual (Board.Queen, ((q 2), []), ((q 3), [])));
      test "moves queen one step backward" (fun() ->
          expect(moveQ (q 2) (-1)) |> toEqual (Board.Queen, ((q 2), []), ((q 1), [])));
    );
  describe "Next setup" (fun () ->
      let pQ2Q3 = (((q 2), [q 3]), ((q 3), [q 4])) in
      test "overrides inital pawn setup after it moves" (fun () ->
        expect((Board.nextSetup (fun _ -> [((q 2), [q 3])]) Board.Pawn pQ2Q3) Board.Pawn) |> toEqual [(q 3), [(q 4)]]);
      test "returns inital queen setup when it does not move" (fun () ->
        expect((Board.nextSetup (fun _ -> [((q 1), [])]) Board.Pawn pQ2Q3) Board.Queen) |> toEqual [(q 1), []]);
    );
