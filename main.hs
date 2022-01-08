import Data.Map (Map, empty, fromList, toList, insert, findWithDefault)
import System.Environment (getArgs)
import System.IO
import Text.Read (readMaybe)

data Ins = INC Int | DEC Int | TST Int | JMP Int | HLT deriving (Show, Read)

parse_ln :: String -> Ins
parse_ln s = case (readMaybe s) of
    Just ins -> ins
    Nothing -> error $ "Invalid instruction: " ++ s

exec_ins :: Map Int Int -> [Ins] -> Int -> IO (Map Int Int)
exec_ins cells ins pc = do
    if pc < 1 || pc > length ins then do -- pc is 1-based
        error $ "Invalid pc: " ++ (show pc)
    else do
        putStrLn $ (show pc) ++ ": " ++ (show $ ins !! (pc - 1))
        case (ins !! (pc - 1)) of
            INC n -> exec_ins (m_mod n ( 1)) ins (pc + 1) -- increase
            DEC n -> exec_ins (m_mod n (-1)) ins (pc + 1) -- decrease
            TST n -> exec_ins cells ins (pc + pcdiff n)   -- [n] == 0?
            JMP n -> exec_ins cells ins n                 -- pc = n
            HLT -> return cells                           -- return current state

    where m_mod c n = insert c ((findWithDefault 0 c cells) + n) cells
          pcdiff c = if (findWithDefault 0 c cells) == 0 then 2 else 1

exec_file :: Handle -> Map Int Int -> IO ()
exec_file h cells = do
    ins <- fmap (map parse_ln . lines) $ hGetContents h
    putStrLn $ "Parsed instructions: " ++ (show ins)

    putStrLn ""
    putStrLn "Executing: "
    res <- exec_ins cells ins 1

    putStrLn ""
    putStrLn "Result:"
    print $ toList res

main = do
    args <- getArgs
    f <- openFile (args !! 0) ReadMode
    if length args > 1 then
        exec_file f $ fromList $ read $ args !! 1
    else
        exec_file f empty
