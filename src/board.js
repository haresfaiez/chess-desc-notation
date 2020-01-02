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

const white = (index, board) => {
  return board[8 - index]
}

const black = (index, board) => {
  return board[index - 1]
}

const whiteAt = (board, fileShorthand, rank) => {
  const fileIsInclined = fileShorthand.length == 2
  const inclinedFile = fileIsInclined ? fileShorthand.split('')[1] : fileShorthand.split('')[0]
  if (fileShorthand.split('')[0] === 'Q') {
    return white(rank, board)[pieces.indexOf(inclinedFile)]
  } else {
    return white(rank, board)[pieces.lastIndexOf(inclinedFile)]
  }
}

module.exports = {
  empty,
  init,
  white,
  black,
  whiteAt
}
