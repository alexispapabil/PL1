use_module(library(assoc)).

read_line(Stream, L) :-
 	read_line_to_codes(Stream, Line),
 	atom_codes(Atom, Line),
 	atomic_list_concat(Atoms, ' ', Atom),
 	maplist(atom_number, Atoms, L).

read_intervals(0,_,Acc,Answer):-
    	rev(Acc,Answer).
read_intervals(N,Stream,Acc,Answer):-
    	read_line(Stream, [Lin, Rin, Lout, Rout]),
    	make_interval(Lin,Rin,Start),
   	make_interval(Lout,Rout,End),
    	bfs_start(Start,End,Path),
    	NN is N-1,
    	read_intervals(NN,Stream,[Path|Acc],Answer).

rev(X,Y):-rev1(X,[],Y).
rev1([],Sofar,Sofar).
rev1([Head|Tail],Sofar,Rev):-
 	rev1(Tail,[Head|Sofar],Rev).

isValid([Lower,Upper],Seen):-
	\+get_assoc([Lower,Upper],Seen,_),
	Upper<1000000.

reached_int([Lower,Upper],[L,U]):-
	Lower>=L,
	Upper=<U.

equals([Lower,Upper],[Lower,Upper]).

make_interval(Lower,Upper,[Lower,Upper]).

getLower([Lower,_],Lower).

halve([Lower,Upper],HOper):-
	NewLower is Lower//2,
	NewUpper is Upper//2,
	make_interval(NewLower,NewUpper,HOper).

triple_plus_one([Lower,Upper],TrOper):-
	NewLower is 3*Lower+1,
        NewUpper is 3*Upper+1,
        make_interval(NewLower,NewUpper,TrOper).

/**Queue code starts here.Code from:http://www.picat-lang.org/bprolog/publib/queues.html **/

make_queue(X-X).

empty_queue(Front-Back):-
  	Front==Back.

join_queue(Element, Front-[Element|Back], Front-Back).

head_queue(Front-Back, Head):-
  	Front\==Back,
  	Front=[Head|_].

serve_queue(OldFront-Back, Head, NewFront-Back):-
  	OldFront\==Back,
  	OldFront=[Head|NewFront].

/**Queue code ends**/

form_path(_,Start,Start,_,'EMPTY').

form_path(Sofar,Start,Head,Path,Answer):-
        get_assoc(Head,Sofar,Previous),
	getLower(Head,LowerH),
	getLower(Previous,LowerP),
        (
		LowerH>LowerP->
        		atom_concat('t',Path,NewPath)
        	;
			atom_concat('h',Path,NewPath)
        ),
        (	equals(Previous,Start)->
         		Answer=NewPath
         	;
			form_path(Sofar,Start,Previous,NewPath,Answer)
        ).

check_next(Head,Q,Seen,Sofar,NewQ,NewSeen,NewSofar):-
        halve(Head,H),
        (
		\+get_assoc(H,Seen,_)->
			put_assoc(H,Seen,1,NSeen),
        		join_queue(H,Q,NQ),
        		put_assoc(H,Sofar,Head,NSofar)
        	;
			NQ=Q,
       			NSeen=Seen,
        	NSofar=Sofar
        ),
        triple_plus_one(Head,Tr),
        (
		isValid(Tr,NSeen)->
			put_assoc(Tr,NSeen,1,NewSeen),
        		join_queue(Tr,NQ,NewQ),
        		put_assoc(Tr,NSofar,Head,NewSofar)
        	;
			NewQ=NQ,
        		NewSeen=NSeen,
        		NewSofar=NSofar
        ).

bfs_start(Start,End,Answer):-
	make_queue(Q),
	put_assoc(Start,t,1,Seen),
	join_queue(Start,Q,NewQ),
	bfs_proceed(Start,End,NewQ,Seen,t,Answer).

bfs_proceed(Start,End,Q,Seen,Sofar,Answer):-
        (
		empty_queue(Q),
         		Answer='IMPOSSIBLE'
 		;
			head_queue(Q,Head),
	 		(
				reached_int(Head,End)->
					form_path(Sofar,Start,Head,'',Answer)
	 			;
					serve_queue(Q,Head,Q0),
	 				check_next(Head,Q0,Seen,Sofar,NewQ0,NewSeen,NewSofar),
	 				bfs_proceed(Start,End,NewQ0,NewSeen,NewSofar,Answer)
	 		)
        ).

ztalloc(File,Answer):-
 	open(File, read, Stream),
 	read_line(Stream, [N]),
 	read_intervals(N,Stream,[],Answer),!.

