use_module(library(clpfd)).

alldiff(L) :-
    include(nonvar,L,Numbers),
    exclude(nonvar,L,Vars),
    length(L, Length),
    findall(X, between(1,Length,X), Xs),
    subtract(Xs, Numbers, Available),
    permutation(Available, Vars).
    
sudoku(L) :-
    maplist(alldiff, L),
    transpose(L, LTranspose),
    maplist(alldiff, LTranspose). 