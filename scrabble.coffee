Object.prototype.clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])
  temp

letters =
	'a': count: 2, score: 1
	'g': count: 1, score: 2
	'm': count: 1, score: 1
	'n': count: 1, score: 4
	'e': count: 1, score: 3

words = [
	'merge'
	'armage'
	'game'
	'manager'
	'mega'
	'manage'
	'gem'
	'damage'
]

getScore = (letters, word) ->
	ls = Object.clone letters
	score = 0
	for char in word
		return if not ls.hasOwnProperty(char) or not ls[char].count
		score += ls[char].score
		delete ls[char] if not --ls[char].count
	score

results = []

for word in words
	score = getScore(letters, word)
	results.push word: word, score: score if score

console.log results.sort (a, b) ->
	b.score - a.score
