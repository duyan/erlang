-module(eightqueenimprove).
-export([start/0]).
-define(N,8).

1234567890

start() ->
    [eightqueen(P,[],?N) || P <- lists:seq(1,?N)],
    init:stop().

eightqueen(P,L,1) ->
    case isvalid(P,L,1,length(L)) of
        false -> false;
        true  ->
            io:format("----------------~n"),
            [output(L++[P],Col) || Col <- lists:seq(1,?N)]
    end;

eightqueen(P,L,N) ->
    case isvalid(P,L,1,length(L)) of
        false -> false;
        true  ->
            [eightqueen(P1,L ++ [P],N-1) || P1 <- lists:seq(1,?N)]
    end.

isvalid(P,[H|T],Start,Len) ->
    if
        P =:= H ->
            false;
        abs(P - H) =:= Len + 1 - Start ->
            false;
        true ->
            isvalid(P,T,Start+1,Len)
    end;

isvalid(_P,[],_Start,_Len) ->
    true.

output(L,Col) ->
    lists:foreach(fun(P) -> if
                                P =/= Col ->
                                    io:format("-");
                                true ->
                                    io:format("Q")
                            end
                  end, L),
    io:format("~n").
