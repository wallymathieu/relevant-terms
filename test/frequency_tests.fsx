#load "../lib/relevant_terms.fs"
open RelevantTerms
open RelevantTerms.Frequency
open System.IO
open System
let sentences = 
  File.ReadAllLines("24117.txt") 
  |> Array.collect (fun line-> line.Split([| ';';'.';'!';':' |]))
  |> Array.map(fun sentence -> sentence.Replace(","," ").Replace("\""," ") )
  |> Array.filter(fun l->l.Length>0 && not <| l.StartsWith "[")
let config = {Config.Default with minFrequencyWord=4}
let freq = tripleFrequency sentences config
let str = freq|> Seq.filter(fun (key,value)-> value>4) 
              |> Seq.sortByDescending snd
              |> Seq.map (fun (key,value)-> sprintf "'%s': %d" (String.concat " " (Array.map Token.toKey key)) value)
              |> String.concat Environment.NewLine

Console.WriteLine str
