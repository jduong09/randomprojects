def caesar_cipher(str, skips)
  # creates an array of characters that make up the alphabet and stores it in a variable, 'alphabet'
  alphabet = ("a".."z").to_a

  # splits the input string into an array, so that it can be iterated through.
  arrOfStr = str.split("")

  # creates an empty array, so that we can store the caesar cipher version of the input string.
  caesarArr = []

  # iterating through the array of characters of the inputed string, finding the index of the character in the alphabet, moving it based on the input skips integer, then adding it to the empty array.
  arrOfStr.each do |char|
    #check if the character is cap, making it not capitalized. (specific to the first letter of the word.)
    isCharCap = false
    if char == char.upcase
      isCharCap = true
    end

    # find the index where the character in the string is located in our alphabet array.
    charIndex = alphabet.find_index(char.downcase)

    # if we cannot find the index, then the character is not a letter in the alphabet. I did this because then it would be a space, or punctuation, and i don't want to caesar_cipher anything that is not a letter in the alphabet. 
    # so just add it to our caesarcipher Arr.
    if charIndex == nil
      caesarArr << char
      next
    end

    # adding the index we found with the skips, which will give us the caesarcipher index of the character we are currently working on.
    caesarIndex = charIndex + skips
    # if we do the addition of the skips and are out of range of the alphabet (alphabet is 26 characters.), then when we go back into the array of alphabet to look for out new letter, it will return nil. 
    # to solve this, we subtract our greater than 26 number by 26, which essentially puts us back at the beginning of the alphabet.
    if caesarIndex > 26
      caesarIndex -= 26
    end

    #find our caesar letter.
    caesarLetter = alphabet[caesarIndex]
    
    #if our letter was capitalized before we ran caesarcipher (first letter in the word), then we need to capitalize it before our final answer.
    if isCharCap
      caesarArr << caesarLetter.upcase
    else
      caesarArr << caesarLetter
    end
  end

  # iteration is complete, each character should have been through the caesar cipher, join the array, creating a string and that will be our answer!
  caesarArr.join
end 

p caesar_cipher("What a string!", 5) # "Bmfy f xywnsl!"