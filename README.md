# Problem Solving with Prolog

Here stores my own Prolog implementation to solve the classic problems or return the outcome of card games. Currently being updated.

To run, `swipl` is required:
* Type `swipl` to terminal
* Type in the file you want to run in square backets, then full stop. For example, if you want to load `sudoku.pl`, type `[sudoku].`.
* Further instructions are written specifically for each program.

## Containers

Given 2 containers with a capacity of 3 and 5 litres respectively, using only the actions `Fill`,`Empty`, and `Pour` all content from one to another, get the bigger container to contain 4 litres.

```Prolog
% To run for classic case, starting with empty containers
containers(Moves).

% To run for customized start case, here in this example, 2 and 5 litres respectively
containers([2,5],Moves).
```

## Cribbage

***Original code was used for COMP30020 Project 1. It has been modified to avoid copying. If you try to copy, you will get caught for academic misconduct. Even if copy is not detected, you will get a low score for incorrect implementation, so proceed at your own risk.***

[How To Play & Strategy](https://bicyclecards.com/how-to-play/cribbage/)

There are 2 functions:
* `hand_value/2` that calculates the outcome value of a combination
* `select_hand/3` that choose the most suitable cards to put to the Crib.

## Sudoku

[9x9 Sudoku Rule](https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/).

The program is also applicable for small-sized sudoku problems. So far, the square block rule is relaxed.

```Prolog
% To run:
run_sudoku([
    Your_problem_here
]).

% To represent your sudoku problem:
% * Each row is an array
% * Each row is separated by a coma (',')
% * Unknown values are represented by different variable names that start with a capital letter e.g. X1, X2, X3,... Unknown values do not share the same variable name!

% Here is an example:
run_sudoku([

[1 , 2 , 3 ],
[2 , X1, 1 ],
[X2, X3, X4]
        
]).

```