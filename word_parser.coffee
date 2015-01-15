http = require 'http'
fs = require 'fs'

translateParser =

  #alphabet: ['\'', 'ა', 'ბ', 'გ', 'დ', 'ე', 'ვ', 'ზ', 'თ', 'ი', 'კ', 'ლ', 'მ', 'ნ', 'ო', 'პ', 'ჟ', 'რ', 'ს', 'ტ', 'უ', 'ფ', 'ქ', 'ღ', 'ყ', 'შ', 'ჩ', 'ც', 'ძ', 'წ', 'ჭ', 'ხ', 'ჯ', 'ჰ']

  alphabet: ['ა', 'მ', 'ი', 'ო']
  
  letterCount: 4

  wordlist: []

  translate: (number) ->
    result = ''
    for i in [0...number.length]
      result += @.alphabet[parseInt number.charAt(i), @.alphabet.length]
    result

  parse: (i) ->
    word = @.translate i.toString @.alphabet.length
    options =
      hostname: 'next.translate.ge'
      port: 80
      path: '/api/' + word
      method: 'GET'
    chunkStore = ''
    req = http.request options, (res) =>
      return unless res.statusCode is 200
      res.setEncoding 'utf8'
      res.on 'data', (chunk) ->
        chunkStore += chunk
      res.on 'end', () =>
        jsonData = JSON.parse chunkStore
        for word in jsonData.rows
          console.log @.wordlist
          parsedWord = word.key.match /[ა-ჰ]+/
          @.wordlist.push parsedWord[0] if parsedWord? and parsedWord[0] not of @.wordlist
    req.on 'error', (e) -> console.log "problem with request: #{e.message}"
    req.end()
  
  init: (letters) ->
    @.alphabet = (letter for letter of letters when letters.hasOwnProperty letter)
    @.parse i for i in [0...Math.pow @.alphabet.length, @.letterCount]

translateParser.init(['ა', 'ბ'])