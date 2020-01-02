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

// fileShorthand can have two-letters "KB" (king-bishop) where the first is the side (king or queen)
// or one-letter "K" or "Q"
const whiteAt = (board, fileShorthand, rank) => {
  const side = fileShorthand.split('')[0]
  const inclinedFile = fileShorthand.split('')[1] || side

  if (side === 'Q') {
    return white(board, rank)[pieces.indexOf(inclinedFile)]
  } else {
    return white(board, rank)[pieces.lastIndexOf(inclinedFile)]
  }
}

const blackAt = (board, fileShorthand, rank) => {
  const side = fileShorthand.split('')[0]
  const inclinedFile = fileShorthand.split('')[1] || side

  if (side === 'Q') {
    return black(board, rank)[pieces.indexOf(inclinedFile)]
  } else {
    return black(board, rank)[pieces.lastIndexOf(inclinedFile)]
  }
}

module.exports = {
  empty,
  init,
  white,
  black,
  whiteAt,
  blackAt
}
