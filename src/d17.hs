module D17 where 
    import Data.List.Split (splitOn)
    import Data.List (partition, groupBy, head, sortBy)
    import Data.Ord (comparing)
    import Data.Function ((&), on)

    input = readFile "inputs/d17"
    inputLines = input >>= return . splitOn "\n"

    buildDeltas (_:tl) = [-1,0,1]:buildDeltas tl
    buildDeltas [] = []

    buildZero = map (\x -> 0) 

    combine :: [[a]] -> [a] -> [[a]]
    combine prefix (suffix:tl) = [ p ++ [ suffix ] | p <- prefix ] ++ combine prefix tl
    combine prefix [] = []

    combineAll prefix (x:t) = combineAll (combine prefix x) t
    combineAll prefix [] = prefix 

    (x:t1) +++ (y:t2) = (x + y):(t1+++t2)
    l +++ [] = l 
    [] +++ l = l 
    
    neighbors (active, inactive) cur cube =
        let zero = buildZero cur
            (act, inact) = [ cur +++ d | d <- combineAll [[]] (buildDeltas cur), d /= zero ] & partition (\x -> x `elem` cube) in 
                (active ++ [ (cur, neig) | neig <- act ], inactive ++ [ (neig, cur) | neig <- inact])

    activeInactive (active, inactive) (cur:other) cube = activeInactive (neighbors (active, inactive) cur cube) other cube
    activeInactive (active, inactive) [] _ = (active, inactive)

    loop i maxI cube 
        | i == maxI = cube 
        | otherwise = 
            let (active, inactive) = activeInactive ([], []) cube cube 
                grp = groupBy ((==) `on` fst) . sortBy (comparing fst)
                cubePart1 = [ fst . head $ gr | gr <- grp active, (length gr) `elem` [2,3] ]
                cubePart2 = [ fst . head $ gr | gr <- grp inactive, (length gr) `elem` [3] ]
                cube' =  cubePart1 ++ cubePart2 in
                    loop (i+1) maxI cube'
    
    inSpace i j n = i:j:[ 0 | _ <- [2..(n-1)]]

    p space = do 
        lines <- inputLines
        let cube = [ inSpace i j space | i <- [0 .. (length lines) - 1], j <- [0 .. (length $ lines !! i) - 1], lines !! i !! j == '#' ]
        let cube' = loop 0 6 cube
        let res = length cube'
        return res