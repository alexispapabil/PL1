structure map = BinaryMapFn(struct 
  type ord_key = int
  val compare = Int.compare
end)

fun init m 0 = m
  | init m k = init (map.insert (m,k,0)) (k-1)

fun min a b = 
  case a > b of
       true => b
     | false => a

fun forth acc [] m k cur = back (rev acc) [] m k cur
  | forth acc (h::t) m k cur = 
  case map.numItems (map.filter (fn x => x <> 0) m) = k of
       false => forth (h::acc) t (map.insert (m,h,valOf(map.find (m,h))+1)) k cur
     | true => back (rev acc) (h::t) m k cur
and back [] _ _ _ cur = cur 
  | back (h::t) acc m k cur = 
  case map.numItems (map.filter (fn x => x <> 0) m) = k of
       true => back t acc (map.insert (m,h,valOf(map.find (m,h))-1)) k (min cur (length (h::t)))
     | false => if acc = nil then cur else forth (rev (h::t)) acc m k cur

fun parse file =
    let
      fun readInt input = 
        Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
      
      val inStream = TextIO.openIn file
      
      val n = readInt inStream
      val k = readInt inStream
      val _ = TextIO.inputLine inStream

      fun readInts 0 acc = acc 
        | readInts i acc = readInts (i - 1) (readInt inStream :: acc)
    in
      (k, n, readInts n [])
    end

fun colors filename = 
   let
     val (k, n, (h::t)) = parse filename
     val ans = forth [] (h::t) (init map.empty k) k (n+1)
     val res = if ans = n+1 then 0 else ans
   in
     print(Int.toString res ^ "\n")
   end
