const pieces = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
const pawns = ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P']

const empty = () => {
  return [
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', ''],
      ['', '', '', '', '', '', '', '']
    ]
}

const init = () => {
  const result = empty()
  result[0] = pieces
  result[1] = pawns
  result[6] = pawns
  result[7] = pieces
  return result
}

const white = (board, rank) => {
  return board[8 - rank]
}

const black = (board, rank) => {
  return board[rank - 1]
}

const pieceInRank = (rank, inclinedFile) => {
  const side = inclinedFile.split('')[0]
  const file = inclinedFile.split('')[1] || side

  // When the file does not contain a side, we consider it on the side of the king
  if (side === 'Q') {
    return rank[pieces.indexOf(file)]
  } else {
    return rank[pieces.lastIndexOf(file)]
  }
}

const whiteAt = (board, file, rank) => {
  return pieceInRank(white(board, rank), file)
}

const blackAt = (board, file, rank) => {
  return pieceInRank(black(board, rank), file)
}

module.exports = {
  empty,
  init,
  white,
  black,
  whiteAt,
  blackAt
}
