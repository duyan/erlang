-module(dummylistener).
-compile(export_all).

start() ->
    inets:start(),
    {ok,ListenSock} = gen_tcp:listen(1500,[binary, {active,false}]),
    wait_connect(ListenSock,0).

wait_connect(ListenSock,Count) ->
    {ok, Socket} = gen_tcp:accept(ListenSock),
    spawn(?MODULE, wait_connect, [ListenSock,Count+1]),
    get_request(Socket, [], Count).

get_request(Socket, BinaryList, Count) ->
%%    case gen_tcp:recv(Socket, 0, 5000) of
    case gen_tcp:recv(Socket, 0, 5000) of
        {ok, Binary} ->
            io:format("~p~n",[Binary]),
            case http:request("http://farm3.static.flickr.com/2490/3876068903_c6e0b29276_o.jpg") of
                {ok, {_Status_line, _Headers, Body}} ->
                    io:format("ok Result:~n"),
                    gen_tcp:send(Socket, Body);
                {error, Reason} ->
                    io:format("Reason:~p~n",[Reason])
            end,
            get_request(Socket, [], Count);
        {error, Closed} ->
            %%handle(lists:reverse(BinaryList), Count),
            %%io:format("Error:~p~n",[Closed]),
            get_request(Socket, [], Count)
    end.

handle(Binary, Count) ->
    io:format("error~n").
