-module(eightqueen).
-export([start/0]).

start() ->
    [eightqueen(P1) || P1 <- lists:seq(1,8)],
    init:stop().

eightqueen(P1) ->
    [eightqueen(P1,P2) || P2 <- lists:seq(1,8),
                          P1 =/= P2,
                          abs(P1-P2) =/= 1 ].

eightqueen(P1,P2) ->
    [eightqueen(P1,P2,P3) || P3 <- lists:seq(1,8),
                             P1 =/= P3,
                             P2 =/= P3,
                             abs(P1-P3) =/= 2,
                             abs(P2-P3) =/= 1 ].

eightqueen(P1,P2,P3) ->
    [eightqueen(P1,P2,P3,P4) || P4 <- lists:seq(1,8),
                                P1 =/= P4,
                                P2 =/= P4,
                                P3 =/= P4,
                                abs(P1-P4) =/= 3,
                                abs(P2-P4) =/= 2,
                                abs(P3-P4) =/= 1 ].

eightqueen(P1,P2,P3,P4) ->
    [eightqueen(P1,P2,P3,P4,P5) || P5 <- lists:seq(1,8),
                                   P1 =/= P5,
                                   P2 =/= P5,
                                   P3 =/= P5,
                                   P4 =/= P5,
                                   abs(P1-P5) =/= 4,
                                   abs(P2-P5) =/= 3,
                                   abs(P3-P5) =/= 2,
                                   abs(P4-P5) =/= 1 ].

eightqueen(P1,P2,P3,P4,P5) ->
    [eightqueen(P1,P2,P3,P4,P5,P6) || P6 <- lists:seq(1,8),
                                      P1 =/= P6,
                                      P2 =/= P6,
                                      P3 =/= P6,
                                      P4 =/= P6,
                                      P5 =/= P6,
                                      abs(P1-P6) =/= 5,
                                      abs(P2-P6) =/= 4,
                                      abs(P3-P6) =/= 3,
                                      abs(P4-P6) =/= 2,
                                      abs(P5-P6) =/= 1 ].

eightqueen(P1,P2,P3,P4,P5,P6) ->
    [eightqueen(P1,P2,P3,P4,P5,P6,P7) || P7 <- lists:seq(1,8),
                                         P1 =/= P7,
                                         P2 =/= P7,
                                         P3 =/= P7,
                                         P4 =/= P7,
                                         P5 =/= P7,
                                         P6 =/= P7,
                                         abs(P1-P7) =/= 6,
                                         abs(P2-P7) =/= 5,
                                         abs(P3-P7) =/= 4,
                                         abs(P4-P7) =/= 3,
                                         abs(P5-P7) =/= 2,
                                         abs(P6-P7) =/= 1 ].

eightqueen(P1,P2,P3,P4,P5,P6,P7) ->
    [eightqueen(P1,P2,P3,P4,P5,P6,P7,P8) || P8 <- lists:seq(1,8),
                                            P1 =/= P8,
                                            P2 =/= P8,
                                            P3 =/= P8,
                                            P4 =/= P8,
                                            P5 =/= P8,
                                            P6 =/= P8,
                                            P7 =/= P8,
                                            abs(P1-P8) =/= 7,
                                            abs(P2-P8) =/= 6,
                                            abs(P3-P8) =/= 5,
                                            abs(P4-P8) =/= 4,
                                            abs(P5-P8) =/= 3,
                                            abs(P6-P8) =/= 2,
                                            abs(P7-P8) =/= 1 ].

eightqueen(P1,P2,P3,P4,P5,P6,P7,P8) ->
    io:format("*********************~n"),
    [output([P1,P2,P3,P4,P5,P6,P7,P8],Col) || Col <- lists:seq(1,8) ].

output(L,Col) ->
    lists:foreach(fun(P) -> if
                                P =/= Col ->
                                    io:format("*");
                                true ->
                                    io:format("@")
                            end
                  end, L),
    io:format("~n").
