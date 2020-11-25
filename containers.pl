%% containers(+Moves) - runs for basic problem: from empty state,
% get the biggercontainer to contain 4 litres
containers(Moves) :- 
    state([0,0], [], Movements), 
    pairs_keys_values(Movements,Moves,_).

%% containers(-InitState, +Moves) - runs for extended problem: 
% from specified initial state, get the bigger container to contain 4 litres
containers(InitState,Moves) :- 
    state(InitState, [], Movements), 
    pairs_keys_values(Movements,Moves,_).

% To customize the destination, change the first argument:
% [_,X] means don't care about the 3-litre container and 5-litre container requires X litres
state([_,4],Moves,Moves).

state(State, MoveSoFar, Moves) :-  
    changeState(Move, State, NewState),
    \+ member(_-NewState, MoveSoFar),
    append(MoveSoFar, [Move-NewState], NewMoves),
    state(NewState, NewMoves, Moves).

changeState(empty(3),[I,X],[0,X]) :- I \= 0.
changeState(empty(5),[X,I],[X,0]) :- I \= 0.
changeState(fill(3) ,[I,X],[3,X]) :- I \= 3.
changeState(fill(5) ,[X,I],[X,5]) :- I \= 5.

changeState(pour(From,To),[X1,Y1],[X2,Y2]) :-
    Vtot is X1+Y1,
    (   (From,To) = (3,5), X1 \= 0,
        (   Vtot > 5,
            Y2 = 5, 
            X2 is X1-5+Y1
        ;   Vtot=< 5, 
            X2 = 0, 
            Y2 is Vtot
        )
    ;   (From,To) = (5,3), 
        Y1 \= 0,
        (   Vtot > 3, 
            X2 = 3, 
            Y2 is X1-3+Y1
        ;   Vtot=< 3,
            Y2 = 0,
            X2 is Vtot
        )
    ).
    
                                         
                                      