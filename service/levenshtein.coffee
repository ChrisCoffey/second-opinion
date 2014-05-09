# ported from:
# http://www.andreimackenzie.com/Levenshtein_Distance_in_JavaScript_(Node.js)/
# https://gist.github.com/982927

exports.getEditDistance = (a, b) ->
  return b.length  if a.length is 0
  return a.length  if b.length is 0
  matrix = []
  
  # increment along the first column of each row
  i = 0
  while i <= b.length
    matrix[i] = [i]
    i++
  
  # increment each column in the first row
  j = 0
  while j <= a.length
    matrix[0][j] = j
    j++
  
  # Fill in the rest of the matrix
  i = 1
  while i <= b.length
    j = 1
    while j <= a.length
      if b.charAt(i - 1) is a.charAt(j - 1)
        matrix[i][j] = matrix[i - 1][j - 1]
      else
        matrix[i][j] = Math.min(matrix[i - 1][j - 1] + 2, Math.min(matrix[i][j - 1] + 1, matrix[i - 1][j] + 1)) # deletion
      j++
    i++
  matrix[b.length][a.length]