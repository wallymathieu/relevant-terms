module RelevantTerms
open System
type Token=Word of string
           | Term
with
  member this.ToKey()=
    match this with
    | Word w->w
    | Term ->":term"
module Token=
  let toKey (this:Token)=this.ToKey()
type DownCasedSentence(rawSentence:string)=
  let sentence = rawSentence.ToLowerInvariant() 
  let words =sentence.Split([|' '|], StringSplitOptions.RemoveEmptyEntries)
  member __.Sentence=sentence
  member __.Words = words
  member __.Raw = rawSentence

module Sentence=
  type DCS=DownCasedSentence
  let raw (sentence:DCS) = sentence.Raw
  let downcase (str:string) = DCS str
  let getWords (sentence:DCS)=sentence.Words

/// Generates 'triples' from the given data string. So if our string were
///     "What a lovely day", we'd generate (What, a, :term) 
///     if lovely is not present so often.
let triples (sentences:DownCasedSentence []) (wordsOfInterest) (maxGramLength:int)=
  let isWordOfInterest w=Set.contains w wordsOfInterest
  let interestingSentences = 
    sentences
    |> Array.choose (fun sentence->
      let words = Sentence.getWords sentence
      if Array.exists isWordOfInterest words then
        Some (sentence, words)
      else
        None)
  let retval = ResizeArray<_>()
  for (_,words) in interestingSentences do
    for i = 0 to words.Length-2 do
      let ws = ResizeArray<_>()
      let mutable j=0
      let mutable last =None
      // the attention span of an average person is supposedly 
      // ca 7 entities (i.e. max gram length), thus lets use that for reference 
      while ws.Count < maxGramLength && i+j < words.Length do
        let w = words.[i+j]
        let t = if isWordOfInterest w then Token.Word w else Term 
        // glob together Term words
        match (last,t) with
        | ((Some Term), Term) -> ()
        | _ ->
          last<-Some t
          ws.Add(t)
        j <- j+1
      if Seq.exists (not << (=) Term) ws then
        retval.Add( ws )
  retval

[<RequireQualifiedAccess>]
module Frequency=
  type Config={
    minFrequencyWord:int
    maxGramLength:int
  }
  with
    static member Default={ minFrequencyWord=2; maxGramLength=7}
  let frequencyOfWords sentences=
    sentences 
    |> Array.collect Sentence.getWords 
    |> Array.groupBy id
    |> Array.map (fun (key,grp)->(key,grp.Length))

  let wordsOfInterest (sentences:DownCasedSentence []) (minFrequencyWord:int)=
    frequencyOfWords sentences
    |> Array.filter( (<=) minFrequencyWord << snd )
    |> Array.map fst

  /// get 'triples' and their frequencies 
  let triples sentences (c:Config)=
    let downCasedSentences = sentences |> Array.map Sentence.downcase
    let wordsOfInterest = wordsOfInterest downCasedSentences c.minFrequencyWord |> Set.ofArray
    let triples = triples downCasedSentences wordsOfInterest c.maxGramLength
    triples
      |> Seq.groupBy Seq.toArray
      |> Seq.map (fun (key,grp)->(key, Seq.length grp))
