# ported from:
# http://www.andreimackenzie.com/Levenshtein_Distance_in_JavaScript_(Node.js)/
# https://gist.github.com/982927

exports.getEditDistance = (a, b) ->
  if a.length is 0
    return b.length
  if b.length is 0
    return a.length

  matrix = []
  for i in [0..b.length]
    matrix[i] = [i]

  for j in [0..a.length]
    matrix[0][j] = j

  for i in [i..b.length]
    for j in [j..a.length]
      if b.charAt(i-1) is a.charAt(j-1)
        matrix[i][j] = matrix[i-1][j-1]
      else
        matrix[i][j] = Math.min(matrix[i-1][j-1] + 2, Math.min(matrix[i][j-1]+1, matrix[i-1][j] + 1))

  matrix[b.length][a.length]

# exports.getEditDistance = function(a, b){
#   if(a.length == 0) return b.length;
#   if(b.length == 0) return a.length;

#   var matrix = [];

#   // increment along the first column of each row
#   var i;
#   for(i = 0; i <= b.length; i++){
#     matrix[i] = [i];
#   }

#   // increment each column in the first row
#   var j;
#   for(j = 0; j <= a.length; j++){
#     matrix[0][j] = j;
#   }

#   // Fill in the rest of the matrix
#   for(i = 1; i <= b.length; i++){
#     for(j = 1; j <= a.length; j++){
#       if(b.charAt(i-1) == a.charAt(j-1)){
#         matrix[i][j] = matrix[i-1][j-1];
#       } else {
#         matrix[i][j] = Math.min(matrix[i-1][j-1] + 2, // substitution
#                                 Math.min(matrix[i][j-1] + 1, // insertion
#                                          matrix[i-1][j] + 1)); // deletion
#       }
#     }
#   }

#   return matrix[b.length][a.length];
# };