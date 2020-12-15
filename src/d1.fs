// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open System.IO

let p1() = 
    let nums = File.ReadAllLines "d1/input" |> Array.map int
    let rec findI i = 
        if i < nums.Length then 
            let rec findJ j = 
                if j < nums.Length then 
                    if nums.[i] + nums.[j] = 2020 then 
                        Some (nums.[i] * nums.[j])
                    else findJ (j+1)
                else None
            match findJ (i+1) with 
            | None -> findI (i+1)
            | v -> v
        else None 
    findI 0

let p2() = 
    let nums = 
        File.ReadAllLines "d1/input" 
        |> Seq.map int
        |> Seq.fold(fun acc num -> 
            Map.change num (function None -> Some 1 | Some c -> Some (c+1)) acc) Map.empty
    let numLst = nums |> Map.toList
    let rec findI =
        function 
        | [] -> None 
        | (num1, c1)::tl -> 
            let rec findJ = 
                function 
                | [] -> None 
                | (num2, c2)::jtl when c2 > 0 -> 
                    let num3 = 2020 - num1 - num2 
                    match Map.tryFind num3 nums with 
                    | Some c when c > 2 -> Some (num1 * num2 * num3)
                    | Some c when c = 2 && (num3 <> num2 || num3 <> num1) -> Some (num1 * num2 * num3)
                    | Some c when c = 1 && (num3 <> num2 && num3 <> num1) -> Some (num1 * num2 * num3)
                    | _ -> findJ jtl 
                | _::jtl -> findJ jtl 
            match findJ ((num1, c1 - 1)::tl) with 
            | None -> findI tl 
            | v -> v
    findI numLst

[<EntryPoint>]
let main argv =
    printfn "%A" (p2())
    0 // return an integer exit code