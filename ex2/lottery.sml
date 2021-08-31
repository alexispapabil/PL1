signature DICT =                    (*source code for trie: https://github.com/jlao/sml-trie ,https://github.com/jlao/sml-trie/blob/master/trie.sml*)
sig
  type key = string                 (* concrete type *)
  type 'a entry = key * 'a          (* concrete type *)

  type 'a dict                      (* abstract type *)

  val empty : 'a dict
  val lookup : 'a dict -> key -> 'a option
  val insert : 'a dict * 'a entry -> 'a dict
end;  (* signature DICT *)

exception InvariantViolationException

structure trie :> DICT = 
struct
  type key = string
  type 'a entry = key * 'a

  datatype 'a trie = 
    Root of 'a option * 'a trie list
  | Node of 'a option * char * 'a trie list

  type 'a dict = 'a trie

  val empty = Root(NONE, nil)

  (* val lookup: 'a dict -> key -> 'a option *)
  fun lookup trie key =
    let
      (* val lookupList: 'a trie list * char list -> 'a option *)
      fun lookupList (nil, _) = NONE
        | lookupList (_, nil) = raise InvariantViolationException
        | lookupList ((trie as Node(_, letter', _))::lst, key as letter::rest) =
            if letter = letter' then lookup' (trie, rest)
            else lookupList (lst, key)
        | lookupList (_, _) =
            raise InvariantViolationException

      (*
        val lookup': 'a trie -> char list
      *)
      and lookup' (Root(elem, _), nil) = elem
        | lookup' (Root(_, lst), key) = lookupList (lst, key)
        | lookup' (Node(elem, _, _), nil) = elem
        | lookup' (Node(elem, letter, lst), key) = lookupList (lst, key)
    in
      lookup' (trie, explode key)
    end

  (*
    val insert: 'a dict * 'a entry -> 'a dict
  *)
  fun insert (trie, (key, value)) = 
    let
      (*
        val insertChild: 'a trie list * key * value -> 'a trie list
        Searches a list of tries to insert the value. If a matching letter 
        prefix is found, it peels of a letter from the key and calls insert'. 
        If no matching letter prefix is found, a new trie is added to the list.
        Invariants:
          * key is never nil.
          * The trie list does not contain a Root.
        Effects: none
      *)
      fun insertChild (nil, letter::nil, value) = 
            [ Node(SOME(value), letter, nil) ]
        | insertChild (nil, letter::rest, value) = 
            [ Node(NONE, letter, insertChild (nil, rest, value)) ]
        | insertChild ((trie as Node(_, letter', _))::lst, key as letter::rest, value) = 
            if letter = letter' then
              insert' (trie, rest, value) :: lst
            else
              trie :: insertChild (lst, key, value)
        | insertChild (Root(_,_)::lst, letter::rest, value) =
            raise InvariantViolationException
        | insertChild (_, nil, _) = (* invariant: key is never nil *)
            raise InvariantViolationException

      (*
        val insert': 'a trie * char list * 'a -> 'a trie
        Invariants:
          * The value is on the current branch, including potentially the current node we're on.
          * If the key is nil, assumes the current node is the destination.
        Effects: none
      *)
      and insert' (Root(_, lst), nil, value) = Root(SOME(value), lst)
        | insert' (Root(elem, lst), key, value) = Root(elem, insertChild (lst, key, value))
        | insert' (Node(_, letter, lst), nil, value) = Node(SOME(value), letter, lst)
        | insert' (Node(elem, letter, lst), key, value) = Node(elem, letter, insertChild (lst, key, value))
    in
      insert'(trie, explode key, value)
    end
end

 (*trie code ends*)

   fun lottery filename=

    let
     fun reverse xs=
         let
           fun rev (nil,z)=z
              |rev (y::ys,z)=rev (ys,y::z)
         in
           rev(xs,nil)
         end

     fun assist tr h []=
         if (trie.lookup tr h=NONE) then trie.insert(tr,(h,1))
         else  trie.insert(tr,(h,valOf(trie.lookup tr h)+1))
        |assist tr h (hs::ts)=
         if(trie.lookup tr h=NONE) then assist (trie.insert(tr,(h,1))) (h^(str hs)) ts
         else assist (trie.insert(tr,(h,valOf(trie.lookup tr h)+1))) (h^(str hs)) ts

     fun addsubkeys tr []=tr
        |addsubkeys tr (h::t)=
           assist tr (str h) t
   
     fun addkeys tr []=tr
        |addkeys tr (h::t)=
           addkeys (addsubkeys tr (reverse(explode h))) t

     fun luckylot tr []=[]
        |luckylot tr (h::t)=
           
           let 
             fun help tr acc []=reverse(acc)
                |help tr acc (h::t)=
                   
                  let 
                     val x=hd(reverse(explode h))
                  in
                   if(trie.lookup tr (str x)=NONE) then help tr (0::acc) t
                   else help tr (valOf(trie.lookup tr (str x))::acc) t
                  end
           in
             help tr [] (h::t)
           end

    fun winlot tr lev cur k x []=(cur mod (IntInf.pow(10,9)+7))
       |winlot tr lev cur k x (h::t)=
            
       let 
          val s=implode(reverse (h::t))
       in 
          if(trie.lookup tr s=NONE orelse (valOf(trie.lookup tr s)=x andalso lev<>k)) then winlot tr (lev-1) cur k x t
          else  
            if(lev=k) then winlot tr (lev-1) (cur+(x*(IntInf.pow(2,lev)-1))) k x t     
            else winlot tr (lev-1) (cur+((valOf(trie.lookup tr s)-x)*(IntInf.pow(2,lev)-1))) k (valOf(trie.lookup tr s)) t     
       end
              
   fun earnings tr acc k []=reverse(acc)
      |earnings tr acc k (h::t)=
        
       let
        val z=explode(h) 
        val y=reverse(z)
        val w=implode(y)   
       in 
         if(trie.lookup tr w=NONE) then earnings tr ((winlot tr k 0 k 0 z)::acc) k t
         else earnings tr ((winlot tr k 0 k (valOf(trie.lookup tr w)) z)::acc) k t
       end

  fun intostr []=[]
   |intostr (h::t)=

    let
       fun huh [] acc=reverse (acc)
          |huh (h::t) acc=huh t ((IntInf.toString h)::acc)
   in
       huh (h::t) []
   end

  fun pr x1 x2=print(IntInf.toString x1 ^ " " ^ IntInf.toString x2 ^ "\n")

  fun app _ [] []=()
     |app _ (h1::t1) []=()
     |app _ [] (h2::t2)=()
     |app f (h1::t1) (h2::t2)=(f h1 h2; app f t1 t2)

 fun howmany 0 s=s
   |howmany num s=howmany (num-1) ("0"^s)

 fun add0 acc k []=rev acc
   |add0 acc k (h::t)=
     if(size h<k) then add0 ((howmany (k-(size h)) h)::acc) k t
     else add0 (h::acc) k t

 fun parse file=
    let
     fun readInt input=
       Option.valOf(TextIO.scanStream(IntInf.scan StringCvt.DEC)input)

       val inStream=TextIO.openIn file
       val k=readInt inStream
       val n=readInt inStream
       val q=readInt inStream
       val _=TextIO.inputLine inStream
       fun readInts 0  acc=reverse acc
        |readInts i acc=readInts (i-1) (readInt inStream::acc)
    in
     (add0 [] (Int.fromLarge k) (intostr(readInts n [])),add0 [] (Int.fromLarge k) (intostr(readInts q [])),(Int.fromLarge k))
    end

     val (l1,l2,k) = parse filename
     val lots=addkeys trie.empty l1
     val winners=luckylot lots l2
     val pot=earnings lots [] k l2
    in 
     app pr winners pot
    end
