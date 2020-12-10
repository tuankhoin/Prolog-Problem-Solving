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

run_sudoku(Problem) :-
    sudoku(Problem),
    maplist(portray_clause, Problem).

% Try run_sudoku([[1,2,3],[2,X1,1],[X2,X3,X4]]).

/* Use this if it makes you feel easier to write the input problem:

run_sudoku([

[1 , 2 , 3 ],
[2 , X1, 1 ],
[X2, X3, X4]
        
]).

*/