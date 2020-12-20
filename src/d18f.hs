module D18f where 
    infixl 7 +++
    (+++) x y = x Prelude.+ y 
    infixl 6 ***
    (***) x y = x Prelude.* y