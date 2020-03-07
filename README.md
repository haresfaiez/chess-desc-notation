# Chess descriptive notation emulator

> Descriptive notation is a notation system for recording chess games which was used in English,
> Spanish and French chess literature until about 1980 (Brace 1977:79–80) (Sunnucks 1970:325).
> [Wikipedia](https://en.wikipedia.org/wiki/Descriptive_notation)

## Test

Use `npm test` to run tests

## Chess notation

### Rank
A row of the chess board. We use numbers from 1 to 8 to denote ranks.

### File
A column of the chess board. We refer to each file using the name of the piece
we put in that column in the initial configuration.

### Pieces
* K : King
* Q : Queen
* Kt: Knight (some notations use `N` here)
* B : Bishop
* R : Rook
* P : Pawn

## Problems with descriptive notation
* `B1` is can be either on the queen side or on the king side. You can specify that as
  `KB1` or `QB1`.

## TCR

### [-]
* Need to commit README updates manually
* Sometimes the test pass because it was badly written, not because it fails (you catch it
in the diff analysis).

### [+]
* Works well with types (those tests won't compile in TDD).
* You get another chance to revert if you leave the git message empty.


## How to
* Emacs `auto-revert-mode`
* Start with failed cases (the non-happy path), e.g Board.move implementation.
