-module(geturl).
-compile(export_all).

-define(HEADER, "src=\"http://img.china.alibaba.com/").
-define(EXT,    "jpg").

geturl(A) ->
    {ok,FileId} = file:open(A,read),
    case readlines(FileId) of
        {ok, LinesList} ->
            case filter(LinesList) of
                ok ->
                    ok;
                error ->
                    io:format("file filter error in ~p : ~n",[?LINE])
            end;
        {error, Reason} ->
            io:format("file load error : ~p~n",[Reason]),
            exit(filereaderror)
    end,
    init:stop().

readlines(FileId) ->
    readlines_tr(FileId,[]).

readlines_tr(FileId,L) ->
    case io:get_line(FileId,'') of
        {error, Reason} ->
            io:format("file load error in ~p : ~p~n",[?LINE, Reason]),
            {error, Reason};
        eof ->
            file:close(FileId),
            {ok, lists:reverse(L)};
        Data ->
            %%io:format("~s~n",[Data]),
            readlines_tr(FileId, [Data|L])
    end.

filter([]) ->
    ok;

filter([H|T]) ->
    _Pid = spawn(fun() -> Index = string:str(H,?HEADER),
                          filter(H,Index)
                          end ),
    filter(T).

filter(_H,I) when I =:= 0 ->
    ok;

filter(H,Index) ->
    SubStr = string:substr(H,Index+5),
    %%io:format("~s~n",[SubStr]),
    EndIndex = string:str(SubStr,?EXT),
    io:format("~s~n",[string:substr(SubStr,1,EndIndex+2)]),
    SubStr2 = string:substr(SubStr,EndIndex+4),
    StartIndex = string:str(SubStr2,?HEADER),
    filter(SubStr2,StartIndex).
