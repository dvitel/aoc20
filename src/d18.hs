module D18 where 
    import Data.List.Split (splitOn) 
    import Data.List (intercalate)
    import Data.Function ((&))
    import Language.Haskell.Interpreter

    evalLine :: String -> Interpreter [Int]
    evalLine line = do 
        loadModules ["src/d18f.hs"]
        setTopLevelModules ["D18f"]
        setImports ["Prelude"]          
        interpret line (as :: [Int])
        -- eval line

    replace ('+':other) = "+++" ++ replace other
    replace ('*':other) = "***" ++ replace other
    replace (x:other) = x:replace other
    replace [] = []

    main :: IO ()
    main = 
        do 
        content <- readFile "inputs/d18"
        let lines = "[" ++ intercalate "," ([ replace line | line <- splitOn "\n" content, line /= "" ]) ++ "]"
        res <- runInterpreter $ evalLine lines
        case res of 
            Right lst -> 
                print $ sum lst 
            Left e -> 
                print e 


--145575710203332         
--145575710203332       