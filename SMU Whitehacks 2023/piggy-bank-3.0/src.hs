import System.IO
import System.Exit
import Data.IORef
import System.IO.Unsafe

-- global integer variable to hold money and unimportant initialization
{-# NOINLINE bank_money #-}
bank_money :: IORef Int
-- bank money is initialized to 0
bank_money = unsafePerformIO $ newIORef 0
{-# NOINLINE user_money #-}
user_money :: IORef Int
-- user money is initialized to 100
user_money = unsafePerformIO $ newIORef 100

strlen :: String -> Int
strlen input = Prelude.length $ Prelude.takeWhile (/= '\0') input

atoi :: String -> Int
atoi input = do
    -- check if input is negative and process accordingly
    if (input !! 0 == '-') then do
        let input' = Prelude.filter (\x -> x >= '0' && x <= '9') (tail input)
        Prelude.read input' * (-1) :: Int
    else do
        let input' = Prelude.filter (\x -> x >= '0' && x <= '9') input
        Prelude.read input' :: Int

-- function to print balance
print_balance :: IO ()
print_balance = do
    -- read current money in wallet and piggy bank
    current_user_money <- readIORef user_money
    current_bank_money <- readIORef bank_money
    putStrLn ("\nPiggy Bank value: " ++ (show current_bank_money))
    putStrLn ("Wallet value: " ++ (show current_user_money))    

-- function to print the menu
print_menu :: IO ()
print_menu = do
    putStrLn("1. Deposit into Piggy bank")
    putStrLn("2. Withdraw from Piggy bank")
    putStrLn("3. Buy Flag")
    putStrLn("4. Exit")

-- function to deposit money into the piggy bank
deposit :: IO ()
deposit = do
    putStr("Enter amount to deposit: ")
    input <- getLine
    -- check if input is not empty and length of input is 2
    -- this bank is not accepting deposits of more than 99
    if (strlen input == 2 && input !! 0 /= '0') then do
        let amount = atoi input
        -- read current money in wallet and piggy bank
        current_user_money <- readIORef user_money
        current_bank_money <- readIORef bank_money
        -- check if wallet contains enough money
        if (amount <= current_user_money) then do
            -- update money in wallet and piggy bank
            writeIORef user_money (current_user_money - amount) -- user_money -= amount
            writeIORef bank_money (current_bank_money + amount) -- bank_money += amount
        else do
            putStrLn("[-] Error: Not enough money in wallet")
    else do
        putStrLn("[-] Error: Invalid amount")

-- function to withdraw money from the piggy bank
withdraw :: IO ()
withdraw = do
    putStr("Enter amount to withdraw: ")
    input <- getLine
    -- check if input is not empty and length of input is 2
    -- this bank is not accepting withdrawals of more than 99
    if (strlen input == 2 && input !! 0 /= '0') then do
        let amount = atoi input
        -- read current money in wallet and piggy bank
        current_user_money <- readIORef user_money
        current_bank_money <- readIORef bank_money
        -- check if piggy bank contains enough money
        if (amount <= current_bank_money) then do
            -- update money in wallet and piggy bank
            writeIORef user_money (current_user_money + amount) -- user_money += amount
            writeIORef bank_money (current_bank_money - amount) -- bank_money -= amount
        else do
            putStrLn("[-] Error: Not enough money in piggy bank")
    else do
        putStrLn("[-] Error: Invalid amount")

-- function to buy the flag
buy_flag :: IO ()
buy_flag = do
    -- read flag from file
    flag <- readFile "flag.txt"
    -- read current money in wallet and piggy bank
    current_user_money <- readIORef user_money
    if (current_user_money >= 3133700) then do
        putStrLn("[+] Flag: " ++ flag)
        exitSuccess
    else do
        putStrLn("[-] Error: Not enough money in wallet. Come back when you have $3133700")

-- main function
main = do
    -- Unimportant Initialisation
    hSetBuffering stdin NoBuffering -- disable buffering from STDIN
    hSetBuffering stdout NoBuffering -- disable buffering from STDOUT
    hSetBuffering stderr NoBuffering -- disable buffering from STDERR
    count <- newIORef 0 -- initialize count to 0
    -- print banner
    putStrLn("  ___ _                  ___            _   \n | _ (_)__ _ __ _ _  _  | _ ) __ _ _ _ | |__\n |  _/ / _` / _` | || | | _ \\/ _` | ' \\| / /\n |_| |_\\__, \\__, |\\_, | |___/\\__,_|_||_|_\\_\\\n       |___/|___/ |__/                      \n                 __,---.__\n            __,-'         `-.\n           /_ /_,'           \\&\n           _,''               \\\n          (\")            .    |\n           ``--|__|--..-'`.__|\n")
    -- print menu and wait for user input
    let loop = do
        current_count <- readIORef count
        print_balance
        if (current_count < 10) then do
            writeIORef count (current_count + 1)
            print_menu
            putStr("\nSelect an option: ")
            choice <- getLine
            case choice of 
                "1" -> deposit
                "2" -> withdraw
                "3" -> buy_flag
                "4" -> exitSuccess
                _ -> putStrLn("\n[-] Error: Invalid option")
        else do
            putStrLn("This bank can only support so many withdrawals and deposits. Goodbye!")
            exitSuccess
        loop
    loop


