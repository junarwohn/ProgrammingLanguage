(* Simple Eval *)
datatype expr = NUM of int
              | PLUS of expr * expr
              | MINUS of expr * expr

datatype formula = TRUE
                 | FALSE
                 | NOT of formula
                 | ANDALSO of formula * formula
                 | ORELSE of formula * formula
                 | IMPLY of formula * formula
                 | LESS of expr * expr

fun calc (e) =
  case e of
       NUM(e1) => e1
     | PLUS(e1, e2) => calc(e1) + calc(e2)
     | MINUS(e1, e2) => calc(e1) - calc(e2)

fun eval (e) =
  case e of
       TRUE => true
     | FALSE => false
     | NOT(f) => not( eval(f) )
     | ANDALSO(f1, f2) => eval(f1) andalso eval(f2) 
     | ORELSE(f1, f2) => eval(f1) orelse eval(f2)
     | IMPLY(f1, f2) => not(eval(f1)) orelse eval(f2)
     | LESS(e1, e2) => (calc(e1) < calc(e2))

(* Check MetroMap *)
type name = string

datatype metro = STATION of name
               | AREA of name * metro
               | CONNECT of metro * metro

fun det(s : string, areas) = 
  case areas of
       [] => false
     | c::rest =>
         if c = s
         then true
         else det(s, rest)

fun checkMetro(m) = 
let
  fun cm(mtr, areas) = 
    case mtr of
         AREA(n, m) => cm(m, n::areas)
       | CONNECT(m1, m2) => cm(m1, areas) andalso cm(m2, areas)
       | STATION(n) => det(n, areas)
in
  cm(m, [])
end


datatype 'a lazyList = nullList
                     | cons of 'a * (unit -> 'a lazyList) 


fun sq(s : 'a lazyList, lazyListVal : 'a list, k) = 
  if k = 0
  then lazyListVal 
  else
    case s of
         cons(first, ms) => first::sq(ms(), lazyListVal, k - 1)
       | nullList => lazyListVal

fun seq(first, last) =
let 
  fun mk_cons() =
    if first >= last 
    then nullList
    else seq(first + 1, last)
in
  if first > last
  then nullList 
  else cons(first, mk_cons)
end

fun infSeq(first) =
let
  fun mk_cons() =
    infSeq(first + 1)
in
  cons(first, mk_cons)
end

fun reverse(xs) =
let 
  fun f(os, rs) =
    if null(os)
    then rs
    else f(tl(os), hd(os) :: rs)
in
  f(xs, [])
end

fun firstN(lazyListVal, n) = 
let
  fun extr(lzlv, k, l) =
    if k = 0
    then l
    else
      case lzlv of
           nullList => l
         | cons(f, c) => extr(c(), k - 1, f::l)
  val xs = extr(lazyListVal, n, [])
in
  reverse(xs)
end

fun Nth(lazyListVal, n) =
  case (lazyListVal, n) of
       (nullList, _) => NONE
     | (cons(f, c), 1) => SOME(f)
     | (cons(f, c), n) => Nth(c(), n - 1)


fun filterMultiples(lazyListVal, n) = 
let
  fun det(k) = ((k mod n) = 0)
  fun mk_cons() =
    case lazyListVal of
         nullList => nullList
       | cons(f, c) => filterMultiples(c(), n)
in
  case lazyListVal of
       nullList => nullList
     | cons(f, c) => 
         if det(f)
         then filterMultiples(c(), n)
         else cons(f, mk_cons)
end

fun ceil_sqrt(s, target) =
  if s * s >= target 
  then s
  else ceil_sqrt(s + 1, target)


fun infSeq(first) =
let
  fun mk_cons() =
    infSeq(first + 1)
in
  cons(first, mk_cons)
end

(*
fun mk_list(s, e) =
  if s = e
  then [e]
  else s::mk_list(s + 1, e)

fun get_end(xs) = 
  case xs of
       (x::[]) => x
     | (x::xt) => get_end(xt)
     | [] => 0
*)

fun is_prime(p) = 
let
  fun divide_prime(sn, en, target) =
    if sn = en
    then true
    else
      if target mod sn = 0
      then false
      else divide_prime(sn + 1, en, target)
in
  divide_prime(2, ceil_sqrt(1, p), p)
end

(*
fun find_prime(p) = 
let
  fun filter_x(xs) =
  let
    val x = hd(xs)
    fun cutting(s) = 
      case s of
           [] => []
         | (f::t) =>
             if f mod x = 0
             then cutting(t)
             else f::cutting(t)
  in
    case xs of
         (first::[]) => xs
       | (first::tail) => x::filter_x(cutting(tail))
       | [] => []
  end
  val k = filter_x(mk_list(2, p))
in
  if p = get_end(k) 
  then true
  else false
end
*)

fun primes() =
let
  fun sieve(lazyListVal) =
  let
    fun mk_cons() =
      case lazyListVal of
           cons(f, infseq_c) => sieve(infseq_c())
         | _ => nullList
  in
    case lazyListVal of
         cons(f, infseq_c) =>
         if is_prime(f)
         then cons(f, mk_cons)
         else sieve(infseq_c())
       | _ =>
           nullList
  end
in
  sieve(infSeq(2))
end
