module FrequenceyTests
open RelevantTerms
open System.IO
open System
open Expecto
let sentencesFrom24117 = 
  File.ReadAllLines("test/24117.txt") 
  |> Array.collect (fun line-> line.Split([| ';';'.';'!';':' |]))
  |> Array.map(fun sentence -> sentence.Replace(","," ").Replace("\""," ") )
  |> Array.filter(fun l->l.Length>0 && not <| l.StartsWith "[")
let config = {Config.Default with minFrequencyWord=5}
[<Tests>]
let tests = 
    testList "A test group" [
        testCase "one test" <|
            fun _ -> 
              let freq = Frequency.triples sentencesFrom24117 config
              let str = freq|> Seq.filter(fun (key,value)-> value>4) 
                            |> Seq.sortByDescending snd
                            |> Seq.map (fun (key,value)-> sprintf "'%s': %d" (String.concat " " (Array.map Token.toKey key)) value)
                            |> String.concat Environment.NewLine
              let expected = @"'the :term': 25
'a :term': 15
':term and :term': 13
'her :term': 8
':term the': 8
'was :term': 7
':term to :term': 7
':term the :term': 7
'and :term': 7
':term and': 7
'to :term': 6
'very :term': 6
':term a :term': 5
'be :term': 5
':term in the :term': 5
':term little red': 5
':term my child': 5"
              Expect.equal str expected "Can get counts"
    ]
