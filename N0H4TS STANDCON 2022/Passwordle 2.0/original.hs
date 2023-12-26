import Control.Monad
import Data.ByteString (ByteString)
import Data.Word
import Data.Bits
import Foreign.Marshal.Array
import Foreign.Ptr
import Foreign.Storable
import qualified Data.ByteString as BS
import Data.ByteString.UTF8 as BSU      -- from utf8-string
import System.IO
import System.Random
import System.IO.Unsafe
import System.Process
import System.Exit

randomPassword :: Word -> ByteString
randomPassword size | (size >= 100) = BSU.fromString (nChars 100 $ randomRs ('!','~') $ unsafePerformIO newStdGen)
                    | (size > 0) = BSU.fromString (nChars size $ randomRs ('!','~') $ unsafePerformIO newStdGen)

checkSize :: Integer -> Word
checkSize size | (size >= 100) = fromInteger(16) :: Word
               | (size >= 0 && size <= 2) = fromInteger(2) :: Word
               | (size < 100) = fromInteger(size) :: Word

nChars :: Word -> String -> String
nChars 0 _      = []
nChars n (x:xs)
    | n > 0     = x : nChars (n-1) xs
    | otherwise = []
nChars _ _      = []

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

fromBytes :: ByteString -> Int
fromBytes = BS.foldl' f 0
  where
    f a b = a `shiftL` 8 .|. fromIntegral b

main = do
    hSetBuffering stdin NoBuffering -- disable buffering from STDIN
    hSetBuffering stdout NoBuffering -- disable buffering from STDOUT
    hSetBuffering stderr NoBuffering -- disable buffering from STDERR
    tmp <- readFile "flag.txt"
    let flag = BSU.fromString tmp
    let huat = (fromBytes flag) `mod` 800000
    putStrLn("\n  ######                                                                     #####        ###\n\ 
            \  #     #   ##    ####   ####  #    #  ####  #####  #####  #      ######    #     #      #   #\n\
            \  #     #  #  #  #      #      #    # #    # #    # #    # #      #               #     #     #\n\
            \  ######  #    #  ####   ####  #    # #    # #    # #    # #      #####      #####      #     #\n\ 
            \  #       ######      #      # # ## # #    # #####  #    # #      #         #       ### #     #\n\
            \  #       #    # #    # #    # ##  ## #    # #   #  #    # #      #         #       ###  #   #\n\  
            \  #       #    #  ####   ####  #    #  ####  #    # #####  ###### ######    ####### ###   ###")
    putStrLn "\n\nPasswordle (THAT IS FIXED) but you CAN specify the length of the password. Guess it correctly on your FIRST TRY and get a FLAGGGGG!\n"
    putStrLn "Input the length of password to randomly generate: "
    buffer <- getLine
    let size = checkSize (read buffer :: Integer)
    let password = randomPassword size
    putStrLn "Enter your guess: "
    buffer <- getLine
    let guess = BSU.fromString (nChars size buffer)
    result <- strcmp huat guess password
    if result then do
        putStrLn "Congrats! You guessed the password!"
        print flag
    else putStrLn "Sorry, your guess is wrong. Try again next time!"
