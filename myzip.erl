-module(myzip).
-compile(export_all).

%%L = [[L11,L12,L13,...],[L21,L22,L23,...],...[Ln1,Ln2,Ln3,...]]
myzip(L) ->
    myzip_tr(L).

myzip_tr(L) ->
    IniAcc0 = array:to_list(array:new(lists:min([length(I) || I <-L ]),{default,[]})),
    Results = [lists:reverse(I) || I <- lists:foldl(fun zipfunc/2, IniAcc0, L )],
    %%io:format("~p~n",[Results]),
    Results.

zipfunc(Elem, AccIn) ->
    %%io:format("~p~n",[AccIn]),
    zipfunc_tr(Elem, AccIn, 1, length(AccIn)).

zipfunc_tr(_,AccIn,_Index,0) ->
    AccIn;
zipfunc_tr([H|T], AccIn, Index, Count) ->
    %%io:format("~p~n",[element(1,lists:split(Index-1,AccIn)) ++
    %%           [[H|lists:nth(Index,AccIn)]] ++ element(2,lists:split(Index, AccIn))]),
    zipfunc_tr(T, element(1,lists:split(Index-1,AccIn)) ++
               [[H|lists:nth(Index,AccIn)]] ++ element(2,lists:split(Index, AccIn)), Index+1, Count-1).
