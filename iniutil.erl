-module(iniutil).
-compile(export_all).

-record(ini,{filename, sections}).

-record(section, {sectionname, keyvalues}).

-record(keyvalue, {key,value}).

start(File) ->
	Ini = new(File),
	print(Ini),
	Sec = querysectionbyname(Ini,"Sec2"),
	io:format("~p~n",[Sec]),
	Key = queryvaluebykey(Ini,"Sec2","key21"),
	io:format("~p~n",[Key]),
	NewIni = setvaluebykey(Ini,"Sec2","key21","value99"),
	io:format("~p~n",[NewIni]),
	savefile(element(2,NewIni),"newtest.ini"),
	init:stop().

new(FileName) ->
	{ok, FileId} = file:open(FileName,read),
	case readlines(FileId) of
		{error, Reason} ->
			{error, Reason};
		{ok, FileContents} ->
			SecLists = analysis(FileContents),
			%io:format("~p~n",[SecLists]),
			#ini{filename=FileName,sections=SecLists}
	end.

print(Ini) ->
	io:format("filename : ~p~n",[Ini#ini.filename]),
	printsections(Ini#ini.sections).

printsections([]) ->
	ok;

printsections([H|T]) ->
	io:format("sectionname : ~s~n",[H#section.sectionname]),
	printkeyvalues(H#section.keyvalues),
	printsections(T).

printkeyvalues([]) ->
	ok;

printkeyvalues([H|T]) ->
	io:format("keyvalue ~s=~s~n", [H#keyvalue.key,H#keyvalue.value]),
	printkeyvalues(T).

querysectionbyname(Ini,Section) ->
   querysection(Ini#ini.sections,Section).

queryvaluebykey(Ini,Section,Key) ->
	case querysectionbyname(Ini,Section) of
		{ok,Sec} ->
			querykey(Sec#section.keyvalues,Key);
		{error,Reason} ->
			{error, Reason}
	end.

setvaluebykey(Ini,Section,Key,Value)->
	case queryvaluebykey(Ini,Section,Key) of
		{ok,K} ->
			NewK = K#keyvalue{value=Value},
			{ok,Sec} = querysectionbyname(Ini,Section),
			NewSec = Sec#section{keyvalues=((Sec#section.keyvalues -- [K]) ++ [NewK])},
			%%io:format("~p~n",[NewSec]),
			NewIni = Ini#ini{sections=((Ini#ini.sections -- [Sec]) ++ [NewSec])},
			{ok,NewIni};
		{error,Reason} ->
			{error,Reason}
	end.

savefile(Ini) ->
	savefile(Ini,Ini#ini.filename).

savefile(Ini,FileName) ->
	{ok, FileId} = file:open(FileName,write),
	savesection(Ini#ini.sections, FileId),
	file:close(FileId),
	ok.


savesection([],_FileId) ->
	ok;
savesection([H|T],FileId) ->
	io:format(FileId,"[~s]~n",[H#section.sectionname]),
	savekeyvalue(H#section.keyvalues,FileId),
	savesection(T,FileId).

savekeyvalue([],_FileId) ->
	ok;
savekeyvalue([H|T],FileId) ->
	io:format(FileId,"~s=~s~n",[H#keyvalue.key,H#keyvalue.value]),
	savekeyvalue(T,FileId).


querysection([],_Section) ->
	{error,noexistsection};
querysection([#section{sectionname=Section,keyvalues=_} = H|_T],Section) ->
	{ok,H};
querysection([_H|T],Section) ->
	querysection(T,Section).

querykey([],_Key) ->
	{error,noexistkey};
querykey([#keyvalue{key=Key,value=_} = H|_T],Key) ->
	{ok,H};
querykey([_H|T],Key) ->
	querykey(T,Key).

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

analysis(FileContents) ->
	analysis_tr(FileContents,[]).

analysis_tr(FileContents, L) ->
	analysis_tr(FileContents,#section{sectionname="",keyvalues=[]},L).

analysis_tr([],Section,L) ->
	%%io:format("~p~n",[L]),
	lists:reverse([Section|L]);

analysis_tr([H|T],Section, L) ->
	%%io:format("~p~n",[H]),
	case SH = string:strip(H) of
		"#"++_ ->
			analysis_tr(T,Section,L);
		"\n" ->
			analysis_tr(T,Section,L);
		"["++SecName ->
			if
				Section#section.sectionname =/= "" ->
					NewL = [Section|L];
				true -> NewL = L
			end,
			analysis_tr(T,Section#section{sectionname=string:substr(SecName,1,string:len(SecName)-2),keyvalues=[]},NewL);
		_ ->
			Tokens = string:tokens(string:substr(SH,1,string:len(SH)-1),"="),
			case length(Tokens) of
				2 ->
					Element = #keyvalue{key=lists:nth(1,Tokens),value=lists:nth(2,Tokens)},
					analysis_tr(T,Section#section{keyvalues=[Element|Section#section.keyvalues]},L);
				_ -> ok
			end
	end.
