-module(bombardier).
-export([run/2]).

-define(URL, "https://10.208.56.11:443/").
-define(TIMEOUT, infinity).

run(0, _N) ->
    ok;
run(M, N) ->
    get_procs(fun long_request/0, N),
    timer:sleep(10000),
    run(M - 1, N).

long_request() ->
    Url = ?URL ++ "chunk/60/10000",  % 10 minutes
    case lhttpc:request(Url, "GET", [], [], ?TIMEOUT, []) of
        {ok, {{200, _}, _Headers, _Response}} ->
            io:format("ok~n", []);
        {ok, {{500, _}, _Headers, _Response}} ->
            io:format("500~n", [])
    end.

get_procs(F, N) ->
    get_procs(F, N, []).

get_procs(_F, 0, Pids) ->
    Pids;
get_procs(F, N, Pids) ->
    case N rem 100 of
	0 ->
	    timer:sleep(100),
    io:format(".", []);
_ ->
	    ok
    end,
    get_procs(F, N - 1, [spawn(F) | Pids]).
