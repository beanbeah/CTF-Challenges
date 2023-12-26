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

a :: Word -> ByteString
a b | (b >= 100) = BSU.fromString (c 100 $ randomRs ('!','~') $ unsafePerformIO newStdGen)
    | (b > 0) = BSU.fromString (c b $ randomRs ('!','~') $ unsafePerformIO newStdGen)

b :: Integer -> Word
b a | (a >= 100) = fromInteger(100) :: Word
    | (a >= 0 && a <= 2) = fromInteger(2) :: Word
    | (a < 100) = fromInteger(a) :: Word

c :: Word -> String -> String
c 0 _      = []
c n (x:xs)
    | n > 0 = x : c (n-1) xs
    | otherwise = []
c _ _      = []

d :: Int -> ByteString -> ByteString -> IO Bool
d e a b =
    allocaArray e $ \y -> do
        let l = e `div` 2
            c = BS.length a
            d = BS.length b
            z = plusPtr y l
        when (c > e || d > e) $ exitFailure
        pokeArray z (BS.unpack b)
        when (d < l) $ pokeArray (plusPtr z d) (replicate (l - d) (0 :: Word8))
        pokeArray y (BS.unpack a)
        when (c < l) $ pokeArray (plusPtr y c) (replicate (l - c) (0 :: Word8))
        and <$> forM [0..(l-1)] (\i -> do
            f <- peekByteOff y i :: IO Word8
            w <- peekByteOff z i
            return $ f == w)

e :: ByteString -> Int
e = BS.foldl' f 0
  where
    f a b = a `shiftL` 8 .|. fromIntegral b

main = do
    hSetBuffering stdin NoBuffering -- disable buffering from STDIN
    hSetBuffering stdout NoBuffering -- disable buffering from STDOUT
    hSetBuffering stderr NoBuffering -- disable buffering from STDERR
    tmp <- readFile "flag.txt"
    let flag = BSU.fromString tmp
    let dd = (e flag) `mod` 800000 
    putStrLn("\n  ######                                                                     #####        ###\n\ 
            \  #     #   ##    ####   ####  #    #  ####  #####  #####  #      ######    #     #      #   #\n\
            \  #     #  #  #  #      #      #    # #    # #    # #    # #      #               #     #     #\n\
            \  ######  #    #  ####   ####  #    # #    # #    # #    # #      #####      #####      #     #\n\ 
            \  #       ######      #      # # ## # #    # #####  #    # #      #         #       ### #     #\n\
            \  #       #    # #    # #    # ##  ## #    # #   #  #    # #      #         #       ###  #   #\n\  
            \  #       #    #  ####   ####  #    #  ####  #    # #####  ###### ######    ####### ###   ###")
    putStrLn "\n\nPasswordle but you CAN specify the length of the password. Guess it correctly on your FIRST TRY and get a FLAGGGGG!\n"
    putStrLn "Input the length of password to randomly generate: "
    buffer <- getLine
    let aa = b (read buffer :: Integer)
    let bb = a aa
    putStrLn "Enter your guess: "
    buffer <- getLine
    let cc = BSU.fromString (c aa buffer)
    result <- d dd cc bb
    if result then do
        putStrLn "Congrats! You guessed the password!"
        print flag
    else putStrLn "Sorry, your guess is wrong. Try again next time!"

