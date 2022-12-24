s  = list("meow, meow, niggers!s")
m, counter = 0, 0
read_pointer =  write_pointer = 0
for c in s:
    if c == " ":
        s[write_pointer] = s[read_pointer] 
        write_pointer+=1
        read_pointer+=1
        m = max(m, counter)
        counter = 0
    elif c.isalpha():
        s[write_pointer] = s[read_pointer]
        read_pointer+=1
        write_pointer+=1
        counter+=1
    else:
        read_pointer+=1
s[write_pointer] = "$"
m = max(m, counter)
print("".join(s))
print(m)
