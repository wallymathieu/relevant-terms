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

//triples
module Frequency=
  type Config={
    minFrequencyWord:int
    maxGramLength:int
  }
  with
    static member Default={ minFrequencyWord=2; maxGramLength=7}

  [<AutoOpen>]
  module internal Internal=
    let getWords(sentence:string)=sentence.Split([|' '|], StringSplitOptions.RemoveEmptyEntries)
    let countFrequency sentences=
      sentences 
      |> Array.collect getWords 
      |> Array.groupBy id
      |> Array.map (fun (key,grp)->(key,grp.Length))

    /// Generates 'triples' from the given data string. So if our string were
    ///     "What a lovely day", we'd generate (What, a, :term) 
    ///     if lovely is not present so often.
    let triples (sentences:string []) (c:Config)= 
      let downCasedSentences = sentences |> Array.map (fun s->s.ToLowerInvariant())
      let wordsOfInterest =
        countFrequency downCasedSentences
        |> Array.filter( (<=) c.minFrequencyWord << snd )
        |> Array.map fst
        |> Set.ofArray
      let isWordOfInterest w=Set.contains w wordsOfInterest
      let interestingSentences = 
        downCasedSentences
        |> Array.choose (fun sentence->
          let words = getWords sentence
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
          while ws.Count < c.maxGramLength && i+j < words.Length do
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
  /// get 'triples' and their frequencies 
  let tripleFrequency sentences c=
    let triples = triples sentences c
    triples
      |> Seq.groupBy Seq.toArray
      |> Seq.map (fun (key,grp)->(key, Seq.length grp))
