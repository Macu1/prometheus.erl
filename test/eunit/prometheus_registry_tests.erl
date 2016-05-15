-module(prometheus_registry_tests).

-export([deregister/1]).

-include_lib("eunit/include/eunit.hrl").

prometheus_registry_test_() ->
  {setup,
   fun start/0,
   fun stop/1,
   fun(ok) ->
       {inparallel, [default_registry(),
                     clear_registry()]}
   end}.

start() ->
  prometheus:start(),
  ok.

stop(ok) ->
  ok.

default_registry() ->
  ?_assertEqual([prometheus_vm_statistics_collector,
                 prometheus_vm_memory_collector],
                prometheus_registry:collectors(default)).

clear_registry() ->
  ok = prometheus_registry:register_collector(custom_registry, prometheus_registry_tests),

  Collectors = prometheus_registry:collectors(custom_registry),
  prometheus_registry:clear(custom_registry),
  [?_assertEqual([prometheus_registry_tests], Collectors),
   ?_assertEqual([], prometheus_registry:collectors(custom_registry))].

deregister(_) -> ok.
