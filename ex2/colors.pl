use_module(library(assoc)).

read_input(File, N, K, C) :-
	open(File, read, Stream),
	read_line(Stream, [N, K]),
	read_line(Stream, C).

read_line(Stream, L) :-
	read_line_to_codes(Stream, Line),
 	atom_codes(Atom, Line),
 	atomic_list_concat(Atoms, ' ', Atom),
 	maplist(atom_number, Atoms, L).

rev(X,Y):-rev1(X,[],Y).
rev1([],Sofar,Sofar).
rev1([Head|Tail],Sofar,Rev):-
 	rev1(Tail,[Head|Sofar],Rev).

has_all([],_,_,_,_,_,_,0).
has_all([H|T],Seen,K,Cur,A,Count,Len,Answer):-
 	NewLen is Len+1,
 	(
		get_assoc(H,A,Val)->
			NewVal is Val+1,
 			put_assoc(H,A,NewVal,NewA),
 			has_all(T,[H|Seen],K,Cur,NewA,Count,NewLen,Answer)
 		;
			put_assoc(H,A,1,NewA),
 			NewCount is Count+1,
 			(
				NewCount=:=K->
					rev([H|Seen],RevS),proceed(RevS,T,NewLen,NewA,NewLen,Answer)
 				;
					has_all(T,[H|Seen],K,Cur,NewA,NewCount,NewLen,Answer)
 			)
	).

proceed(_,[],Cur,_,_,Cur).
proceed([H|T],[H1|T1],Cur,A,Len,Answer):-
 	get_assoc(H,A,Val),
 	NewVal is Val-1,
 	put_assoc(H,A,NewVal,NewA),
 	(
		NewVal=:=0->
  			rev(T,RevT),
  			get_assoc(H1,NewA,Value),
  			NewValue is Value+1,
  			put_assoc(H1,NewA,NewValue,New),
  			(
				Len<Cur->
					search_sub([H1|RevT],T1,Len,New,Len,Answer)
   				;
					search_sub([H1|RevT],T1,Cur,New,Len,Answer)
  			)
  		;
			NewLen is Len-1,
  			(
				NewLen<Cur->
					proceed(T,[H1|T1],NewLen,NewA,NewLen,Answer)
   				;
					proceed(T,[H1|T1],Cur,NewA,NewLen,Answer)
  			)
 	).

search_sub(_,[],Cur,_,_,Cur).
search_sub(L,[H1|T1],Cur,A,Len,Answer):-
	get_assoc(H1,A,Val),
 	NewLen is Len+1,
 	(
		Val=\=0->
 			NewVal is Val+1,
 			put_assoc(H1,A,NewVal,NewA),
 			search_sub([H1|L],T1,Cur,NewA,NewLen,Answer)
 		;
			put_assoc(H1,A,1,NewA),
 			rev([H1|L],RevL),
 			proceed(RevL,T1,Cur,NewA,NewLen,Answer)
	).

colors(File,Answer):-
	read_input(File,N,K,C),
 	NewN is N+1,
 	has_all(C,[],K,NewN,t,0,0,Answer),!.
