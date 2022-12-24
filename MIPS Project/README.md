# Text Message Encryption and Decryption

A MIPS program that does simple encryption/decryption algorithm based on Caesar cipher algorithm for English- based text messages.

* [MIPS Computer Architecture](https://www.mips.com/products/architectures/)
* [Caesar cipher](https://www.geeksforgeeks.org/caesar-cipher-in-cryptography/)

> To read more about the [project](First+Project_+First+2022-2023.pdf).

## Authors
* [Nidal Zabade](https://github.com/NidalZabade) 1200153
* [Mohammad Abu-Shelbaia](https://github.com/mabushelbaia) 1200198

## [Code](https://github.com/NidalZabade/ENCS4370-Computer-Architecture/tree/main/MIPS%20Project/Code)

### Clean text method
```
read_pointer
write_pointer
string s;
max = 0
counter = 0
while s[read_pointer] != null:
  if s[read_pointer].isalpha():
    s[write_pointer] = s[read_pointer] or 32
    read_pointer++
    write_pointer++
    counter++
  else if s[read_pointer] == " ":
    max = max(max, counter)
    counter = 0
    s[write_pointer] = s[read_pointer]
    write_pointer++
    read_pointer++
  else:    # special charachter
    read_pointer++
```

## Todo
- [x] Read from a text file
- [x] Write into a text file
- [x] Max length function
- [x] Remova non-alpha char
- [x] Caesar cipher function
- [ ] test-cases


