use_module(library(assoc)).                                   /**source code for trie: https://github.com/JanWielemaker/tabling_library/blob/master/trie.pl **/
use_module(library(lists)).

p_trie_arity_univ(Term,functor_data(Name,Arity),Arguments) :-
	Term =.. [Name|Arguments],
	functor(Term,_NameAgain,Arity).

trie_new(Trie) :-
	empty_assoc(A),
	Trie = trie_inner_node(maybe_none,A).

trie_is_empty(trie_inner_node(maybe_none,A)) :-
	empty_assoc(A).

trie_get_children(trie_inner_node(_MaybeValue,Children),Children).

trie_get_maybe_value(trie_inner_node(MaybeValue,_Children),MaybeValue).

trie_set_children(Trie,Children) :-
	nb_linkarg(2,Trie,Children).

trie_set_maybe_value(Trie,MaybeValue) :-
	nb_linkarg(1,Trie,MaybeValue).

trie_insert(Trie,Key) :-
	p_trie_arity_univ(Key,FunctorData,KeyList),
	trie_insert_1(KeyList,FunctorData,Trie),!.

trie_insert_1([],FunctorData,Trie) :-
	trie_get_children(Trie,Assoc),
	trie_insert_a(Assoc,Assoc,FunctorData,Trie).
trie_insert_1([First|Rest],FunctorData,Trie) :-
	trie_get_children(Trie,Assoc),
	trie_insert_1_1(Assoc,Assoc,FunctorData,Trie,First,Rest).

trie_insert_a(t,Assoc,FunctorData,Trie) :-
	/*a new key,with value of 1, is stored in trie**/
	trie_new(Subtrie),
  	trie_set_maybe_value(Subtrie,maybe_just(1)),
  	put_assoc(FunctorData,Assoc,Subtrie,NewAssoc),
  	trie_set_children(Trie,NewAssoc).
trie_insert_a(t(K,V,_,L,R),Assoc,FunctorData,Trie) :-
  	compare(Rel,FunctorData,K),
  	trie_insert_b(Rel,V,L,R,Assoc,FunctorData,Trie).

trie_insert_b(<,_V,L,_R,Assoc,FunctorData,Trie) :-
  	trie_insert_a(L,Assoc,FunctorData,Trie).
trie_insert_b(>,_V,_L,R,Assoc,FunctorData,Trie) :-
  	trie_insert_a(R,Assoc,FunctorData,Trie).
trie_insert_b(=,V,_L,_R,_Assoc,_FunctorData,_Trie) :-
  	/**if key exists already, increase existing value by 1**/
  	trie_get_maybe_value(V,Value),
  	Value=maybe_just(JustValue),
  	NewValue is JustValue+1,
  	trie_set_maybe_value(V,maybe_just(NewValue)).

trie_insert_1_1(t,Assoc,FunctorData,Trie,First,Rest) :-
  	trie_new(Subtrie),
  	put_assoc(FunctorData,Assoc,Subtrie,NewAssoc),
  	trie_set_children(Trie,NewAssoc),
  	trie_insert_2(First,Rest,Subtrie).
trie_insert_1_1(t(K,V,_,L,R),Assoc,FunctorData,Trie,First,Rest) :-
  	compare(Rel,FunctorData,K),
  	trie_insert_1_1_1(Rel,V,L,R,Assoc,FunctorData,Trie,First,Rest).

trie_insert_1_1_1(=,V,_L,_R,_Assoc,_FunctorData,_Trie,First,Rest) :-
  	trie_insert_2(First,Rest,V). % V is the Subtrie
trie_insert_1_1_1(<,_V,L,_R,Assoc,FunctorData,Trie,First,Rest) :-
  	trie_insert_1_1(L,Assoc,FunctorData,Trie,First,Rest).
trie_insert_1_1_1(>,_V,_L,R,Assoc,FunctorData,Trie,First,Rest) :-
  	trie_insert_1_1(R,Assoc,FunctorData,Trie,First,Rest).

trie_insert_2(RegularTerm,Rest,Trie) :-
  	p_trie_arity_univ(RegularTerm,FunctorData,KList),
  	append(KList,Rest,KList2),
  	trie_insert_1(KList2,FunctorData,Trie).

trie_lookup(Trie,Key,Value) :-
    	p_trie_arity_univ(Key,FunctorData,KeyList),
    	trie_lookup_1(FunctorData,KeyList,Trie,Value).

trie_lookup_1(FunctorData,Rest,Trie,Value) :-
  	trie_get_children(Trie,Assoc),
  	get_assoc(FunctorData,Assoc,Subtrie),
  	trie_lookup_2(Rest,Subtrie,Value).

trie_lookup_2([],Trie,Value) :-
  	trie_get_maybe_value(Trie,maybe_just(Value)).
trie_lookup_2([RegularTerm|Rest],Trie,Value) :-
  	p_trie_arity_univ(RegularTerm,FunctorData,KList),
  	append(KList,Rest,KList2),
  	trie_lookup_1(FunctorData,KList2,Trie,Value).

/**trie code ends**/

read_line(Stream, L) :-
 	read_line_to_codes(Stream, Line),
	atom_codes(Atom, Line),
 	atomic_list_concat(Atoms, ' ', Atom),
 	maplist(atom_number, Atoms, L).

read_lines(_,0,Acc,L):-
  	rev(Acc,L).
read_lines(Stream, NumLines, Acc, L) :-
 	read_line_to_codes(Stream, Line),
 	atom_codes(Atom, Line),
 	NewNumLines is NumLines-1,
 	read_lines(Stream, NewNumLines, [Atom|Acc], L).

read_input(File, K, N, Q, Lots, W) :-
 	open(File, read, Stream),
 	read_line(Stream, [K, N, Q]),
 	read_lines(Stream, N, [], Lots),
 	read_lines(Stream, Q, [], W),!.

rev(X,Y):-rev1(X,[],Y).
rev1([],Sofar,Sofar).
rev1([Head|Tail],Sofar,Rev):-
 	rev1(Tail,[Head|Sofar],Rev).

formpairs([],[],Acc,L):-
 	rev(Acc,L).
formpairs([H1|T1],[H2|T2],Acc,L):-
 	formpairs(T1,T2,[[H1,H2]|Acc],L).

insert([],_). 
insert([H|T],Trie):-
 	addkeys(H,Trie),
 	insert(T,Trie).

addkeys('',_).
addkeys(Key,Trie):-
  	trie_insert(Trie,Key),
  	sub_atom(Key,1,_,0,NewKey),
  	addkeys(NewKey,Trie).

winners([],Acc,_,L):-
 	rev(Acc,L).

winners([H|T],Acc,Trie,L):-
 	sub_atom(H,_,1,0,Key),
 	(
		trie_lookup(Trie,Key,Value)->
 			winners(T,[Value|Acc],Trie,L)
 		;
			winners(T,[0|Acc],Trie,L)
 	).

earnings([],Acc,_,_,L):-
 	rev(Acc,L).

earnings([H|T],Acc,K,Trie,L):-
 	calc(H,K,0,Trie,K,0,Res),
 	earnings(T,[Res|Acc],K,Trie,L).

calc('',_,_,_,0,Cur,FCur):-
  	pow(10,9,Temp),
  	NTemp is Temp+7,
  	FCur is mod(Cur,NTemp).

calc(Key,K,Val,Trie,Lev,Cur,Res):-
  	sub_atom(Key,1,_,0,NewKey),
  	NLev is Lev-1,
   	(
		trie_lookup(Trie,Key,Value),Value=\=Val->
    			pow(2,Lev,P),
    			NP is P-1,
    			NCur is Cur+NP*(Value-Val),
    			calc(NewKey,K,Value,Trie,NLev,NCur,Res)
    		;
			calc(NewKey,K,Val,Trie,NLev,Cur,Res)
  	).

lottery(File,L):-
 	read_input(File, K, _N, _Q, Lots, W),
	trie_new(Trie),
 	insert(Lots,Trie),
 	winners(W,[],Trie,L1),
 	earnings(W,[],K,Trie,L2),
 	formpairs(L1,L2,[],L),!.
