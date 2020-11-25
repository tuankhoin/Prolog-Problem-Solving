%%%          The University of Melbourne          %%%
%%%      COMP30020 - Declarative Programming      %%%
%%%                   Project 1                   %%%
%%%           Tuan Khoi Nguyen (1025294)          %%%

/** cribbage.pl

This file simulates the card game of Cribbage, by calculating the value
that a hand can make with hand_value/3, or pick the best cards to put in
the crib with select_hand/3.
*/

%------------- Card validation functions --------------%

%% number_rank(?Rank) - succeeds if Rank is a numbered card rank.
% This predicate helps to handle atom ranks to avoid type error when finding
% corresponding card value or order.
number_ranks(Rank):-
    member(Rank,[2,3,4,5,6,7,8,9,10]).

%% rank(?Rank) - succeeds if Rank is a valid card rank.
rank(ace).
rank(jack).
rank(queen).
rank(king).
rank(Rank) :-
    number_ranks(Rank).

%% suit(?Suit) - succeeds if Suit is a valid card suit.
suit(spades).
suit(clubs).
suit(diamonds).
suit(hearts).

%% card(?Rank, ?Suit) 
% Succeeds if Rank and Suit make a valid card to play.
card(Rank, Suit) :-
    rank(Rank),
    suit(Suit).

%% cardval(?Rank, ?Val)
% Returns Val as the corresponding game value of Rank in Cribbage.
cardval(ace,1).
cardval(jack,10).
cardval(queen,10).
cardval(king,10).
cardval(Rank, Rank) :-
    number_ranks(Rank).

% card_order(?Rank, ?Order) - Order is corresponding game
% order (1 to 13) of Rank in Cribbage.
card_order(ace,1).
card_order(jack,11).
card_order(queen,12).
card_order(king,13).
card_order(Rank, Rank) :-
    number_ranks(Rank).

%------------------- Helper predicates --------------------%

%%  card_value_list(+Cards, -List)
%  List is the converted list that contains the hand's 
%  values of corresponding Cards.
card_value_list([],[]).
card_value_list([card(R,_)|Cards], [H|List]) :-
    cardval(R, Val),
    Val = H,
    card_value_list(Cards, List).

%%  card_order_list(+Cards, -List)
%  List is the converted list that contains the hand's
%  order of corresponding Cards.
card_order_list([],[]).
card_order_list([card(R,_)|Cards], [H|List]) :-
    card_order(R, Val),
    Val = H,
    card_order_list(Cards, List).

%%  card_suit_list(+Cards, -List)
%  List is the converted list that only contains the suits of Cards.
card_suit_list([],[]).
card_suit_list([card(_,S)|Cards], [H|List]) :-
    H = S,
    card_suit_list(Cards, List).

%%  flush(?Hand) 
%  Succeeds if Hand contains 4 elements with the same suit.
flush([S, S, S, S]).

%%  streak(+List)
%  Succeeds if List contains elements in running up order.
%  Example: [1,2,3], [3,4,5,6],...
streak([_]).
streak([H1|[H2|List]]) :-
    1 is H2 - H1,
    streak([H2|List]).

%%  sublist(?Subset, +List)
%  Subset is a valid subset of List.
%  [] is also counted as a subset.
sublist([],_).
sublist([X|Xs],[Y|Ys]) :-
    % Either head is beginning of a subset,...
    X = Y,
    sublist(Xs,Ys)
    ;  
    % ...or subset is yet to come   
    sublist([X|Xs],Ys).

%%  sublist_length(?Sub, +List, +L)
%  Sub is a valid subset of List and has length L.
sublist_length(Sub, List, L) :-
    sublist(Sub, List),
    length(Sub, L).

%%  sublist_sum(?Subset, +List, +N)
%  Subset is a valid subset of List that sums up its element to N.
%  [] is counted as a subset that sums to 0.
sublist_sum(Sub, List, N) :-
    sublist(Sub, List),
    sum_list(Sub, N).

%%  sublist_streak(?Sub, +List)
%  Sub is a valid subset of List and has the form of a streak.
sublist_streak(Sub, List) :-
    sublist(Sub, List),
    streak(Sub).

%%  runof(?Streak, +List, +L)
%  Streak is a valid run of legnth L and an element of List.
runof(Streak, List, Length) :-
    member(Streak, List),
    length(Streak, Length).

%----------------- Check for 15s in the set -----------------%

%%  fifteen(+List, -Val)
%  Returns Val, the total points scored for each
%  value groups in List that add up to 15.
%  
%  -Reward 2 points for each group of 15s.
fifteen(List, Val) :-
    % Look for subsets that add its elements to 15
    findall(Sub, sublist_sum(Sub, List, 15), Sublists), 
    % Count number of combinations that satisfy this
    length(Sublists, Length),                           
    Val is Length*2.

%%  fifteen_card(+Cards, -Val) 
%  Returns Val, the total points scored for each card groups in
%  Cards that add up to 15, using fifteen/2 as helper function. 
fifteen_card(Cards, Val) :-
    card_value_list(Cards, List),
    % Retrieve points for 15s
    fifteen(List, Val).        

%------------- Check for Run and Pairs in the set -------------%

%%  pairs(+List, -Val)
%  Returns Val, the total points scored for each pair
%  in List that add up to 15.
%  
%  -List is a sorted List of Card values in the set.
%  -Reward 2 points for each pair of ranks.
pairs(List, Val) :-
    % Look for all identical pairs that are List subset
    findall([X,X], sublist([X,X],List), Sublists),  
    % Count number of pairs
    length(Sublists, Length),                       
    Val is Length*2.

%%  runscore(+List, +Length, -Val)
%  Returns the score Val of the longest streak made (Length is
%  the longest possible length) from the subsets of sorted List.
%
%  -A valid streak has no shorter than 3 elements.
%  -Score is total cards in all longest streak sets.
runscore(List, Length, Val) :-
    % Valid streak consists of 3 cards or more
    ( Length =< 2
    ->  Val is 0
    ;   % Check if there is a streak at the current length
        findall(Run, runof(Run,List,Length), Runlist),
        length(Runlist, N),
        ( N = 0
        ->  % Search for shorter streaks if not
            Newlength is Length-1,
            runscore(List,Newlength,Val)
        ;   % If yes, reward for all streak-of-Length.
            Val is N*Length     
        )
    ).

%%  run(+List, -Val)
%  Begins the search for the longest streak in sorted List
%  and retrieve the score Val.
run(List, Val) :-
    % Retrieve a list of all streaks possible to search in
    findall(Str, sublist_streak(Str,List), Streaks),
    % The longest streak possible is 5 cards in a row
    runscore(Streaks, 5, Val).

%%  run_pairs_card(+Cards, -Val)
%  Returns Val as the total value for pairs and run.
%   
%  -Each pair receives 2 points.
%  -Run reward is longest run streak of components 
%  in List if it is no shorter than 3, and 0 otherwise.
run_pairs_card(Cards, Val) :-
    card_order_list(Cards, List),
    % Sort the order list to find runs
    msort(List, Lsorted), 
    % Find run and pairs separately then add up          
    run(Lsorted, V1),
    pairs(Lsorted, V2),    
    Val is V1+V2.

%------------- Check for flush and nob in the set -------------%

%%  flush_card(+Hand, +Startcard, -Val)
%  Returns Val as the reward for 4 identical suits in
%  the Hand and if there is reward, check if Startcard
%  also have the identical suit to give additional reward. 
%  
%  -4 identical hand suits, different suit in Startcard: 4 points. 
%  -5 identical suits including Startcard: 5 points. 
flush_card(Hand, card(_,Ssuit), Val) :-
    card_suit_list(Hand, [Hsuit|List]),
    % Check for flush in Hand
    ( flush([Hsuit|List])            
    % Check for identical suit with Startcard  
    ->  (Hsuit = Ssuit   
        ->  Val is 5
        ;   Val is 4)
    ;   Val is 0
    ).

%%  nob_card(+Hand, +Startcard, -Val).
%  Returns Val as the additional reward as follows:
%  -1 point for having the jack with Startcard's suit in Hand. 
%  -0 otherwise.
nob_card(Hand, card(_,Ssuit), Val) :-
    ( member(card(jack,Ssuit), Hand)
    ->  Val is 1
    ;   Val is 0
    ).

%--------------- Main predicate hand_value/3 ----------------%

%%  hand_value(+Hand, +Startcard, -Value)
%  Returns Value, the accumulated value of the Hand,
%  in combination with the Startcard.
hand_value(Hand, Startcard, Value) :-

    append(Hand,[Startcard],Starthand),

    % Calculate each combination type's value
    fifteen_card(Starthand, Val1),      % 15s
    run_pairs_card(Starthand, Val2),    % Runs and pairs
    flush_card(Hand, Startcard, Val3),  % Flush
    nob_card(Hand, Startcard, Val4),    % One for his nob

    % Add all values together
    Value is Val1 + Val2 + Val3 + Val4.


%-------------- select_hand/3 helper predicates ----------------%


%%  assumed_value(+Hand, +Startcards, ?Val)
%  Val is the show value when Hand is combined with a start
%  card in Startcards.
assumed_value(Hand, Startcards, Val) :-
    member(Scard, Startcards),
    hand_value(Hand, Scard, Val).

%%  expected_value(+Choice, +Startcards, -Expected)
%  Expected is the total value that Choice made after considering
%  every possible Start card in Startcards.
expected_value(Choice, Startcards, Expected) :-
    findall(Val, assumed_value(Choice, Startcards, Val), Values),
    sum_list(Values, Expected).

%%  choice_value(?Choice, +Cards, +Startcards, -Expected)
%  Expected is the total value that Choice, a 4-card pick from
%  Cards, made after considering every possible Start card in
%  Startcards.
choice_value(Choice, Cards, Startcards, Expected) :-
    sublist_length(Choice, Cards, 4),
    expected_value(Choice, Startcards, Expected).


%--------------- Main predicate select_hand/3 -----------------%


%%  select_hand(+Cards, -Hand, -Cribcards)
%  Hand is the best 4-card combination picked from Cards. The
%  Cribcards are the remainder after the pick to be put to crib.
select_hand(Cards, Hand, Cribcards) :-

    % Retrieve the list of possible start cards
    findall(card(R,S), card(R,S), Deck),
    subtract(Deck, Cards, Startcards),
    
    % Get all combinations and the corresponding expected value
    findall(Expected - Choice, 
        choice_value(Choice,Cards,Startcards,Expected), Outcomes),
    
    % Sort the values to get the one with largest expectation at list end
    % The Hand will be retrieved from this last combination
    keysort(Outcomes, Ordered),
    length(Ordered, L),
    nth1(L, Ordered, _E-Hand),
    
    % Retrieve the Cribcards as well
    subtract(Cards, Hand, Cribcards).
