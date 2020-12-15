// Learn more about F# at http://docs.microsoft.com/dotnet/fsharp

open System
open System.IO
// open System.Text.RegularExpressions

let (|Split|_|) (sep: char) (str: string) = 
    match str.IndexOf(sep) with 
    | -1 -> None 
    | i -> Some(str.[0..i-1], str.[i+1..])
let (|Int|_|) (str:string) = 
    match Int32.TryParse str with 
    | true, v -> Some v 
    | _ -> None

let rec cnt (ch: string) (pwd: string) acc (startIndex: int) = 
    match pwd.IndexOf(ch, startIndex) with 
    | -1 -> acc 
    | i -> cnt ch pwd (acc+1) (i+1)

let p1() =
    File.ReadAllLines "d2/input" 
    |> Seq.sumBy (function 
        | Split '-' (Int minN, Split ' ' (Int maxN, Split ':' (ch, pwd))) -> 
            let c = cnt ch pwd 0 0 
            if c >= minN && c <= maxN then 1 else 0
        | line -> failwithf "Unsupported format %A" line
    )

let p2() =
    File.ReadAllLines "d2/input" 
    |> Seq.sumBy (function 
        | Split '-' (Int p1, Split ' ' (Int p2, Split ':' (ch, pwd))) -> 
            let p1 = p1 - 1 
            let p2 = p2 - 1 
            let pwd = pwd.Trim()
            let atP1 = pwd.IndexOf(ch, p1) = p1
            let atP2 = pwd.IndexOf(ch, p2) = p2
            if (atP1 || atP2) && not(atP1 && atP2) then 1 else 0
        | line -> failwithf "Unsupported format %A" line
    )

(*
let p1() =
    // let regex = Regex("^(?<from>%d*)-(?<to>%d*)\s(?<ch>.):\s(?<pwd>.*)\s*?$")
    File.ReadAllLines "d2/input" 
    |> Seq.map (fun line -> 
        let sep1 = line.IndexOf('-')
        let sep2 = line.IndexOf(' ', sep1+1)
        let sep3 = line.IndexOf(':', sep2+1)
        let minN = line.[0..sep1-1] |> int 
        let maxN = line.[sep1+1..sep2-1] |> int 
        let ch = line.[sep2+1..sep3-1]
        let pwd = line.[sep3+1..] //includes space 
        (minN, maxN, ch, pwd)
    )
    |> Seq.sumBy(fun (minN, maxN, ch, pwd) -> 
        let rec cnt acc (startIndex: int) = 
            match pwd.IndexOf(ch, startIndex) with 
            | -1 -> acc 
            | i -> cnt (acc+1) (i+1)
        let c = cnt 0 0 
        if c >= minN && c <= maxN then 1 else 0
    )
    // |> Seq.toList |> printfn "%A"

let p2() =
    // let regex = Regex("^(?<from>%d*)-(?<to>%d*)\s(?<ch>.):\s(?<pwd>.*)\s*?$")
    File.ReadAllLines "d2/input" 
    |> Seq.map (fun line -> 
        let sep1 = line.IndexOf('-')
        let sep2 = line.IndexOf(' ', sep1+1)
        let sep3 = line.IndexOf(':', sep2+1)
        let minN = line.[0..sep1-1] |> int 
        let maxN = line.[sep1+1..sep2-1] |> int 
        let ch = line.[sep2+1..sep3-1]
        let pwd = line.[sep3+1..] //includes space 
        (minN-1, maxN-1, ch, pwd.Trim())
    )
    |> Seq.sumBy(fun (p1, p2, ch, pwd) -> 
        let atP1 = pwd.IndexOf(ch, p1) = p1
        let atP2 = pwd.IndexOf(ch, p2) = p2
        if (atP1 || atP2) && not(atP1 && atP2) then 1 else 0
    )
*)

[<EntryPoint>]
let main argv =
    printfn "%A" (p1())
    0 // return an integer exit code