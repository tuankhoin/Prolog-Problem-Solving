alldiff(L) :-
    include(nonvar,L,Numbers),
    exclude(nonvar,L,Vars),
    length(L, Length),
    Max is Length - 1,
    findall(X, between(0,Max,X), Xs),
    subtract(Xs, Numbers, Available),
    permutation(Available, Vars).
    