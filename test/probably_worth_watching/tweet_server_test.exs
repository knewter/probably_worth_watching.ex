defmodule CollectorServer do
  use GenServer

  def start(_) do
    GenServer.start(__MODULE__, [])
  end

  def handle_in(pid, {:event, event}) do
    GenServer.call(pid, {:event, event})
  end

  def events(pid) do
    GenServer.call(pid, :get_events)
  end

  def init([]) do
    {:ok, []}
  end

  def handle_call({:event, event}, _from, state) do
    {:reply, :ok, [{:event, event}|state]}
  end
  def handle_call(:get_events, _from, state) do
    {:reply, state, state}
  end
end

defmodule ProbablyWorthWatching.TweetServerTest do
  use ExUnit.Case
  alias ProbablyWorthWatching.TweetServer

  test "adding a sink and handling an inbound event" do
    sink_node = ProbablyWorthWatching.Node.new(CollectorServer, [])
    {:ok, tweet_server} = TweetServer.start("sometermthatwontmatchasearchideally")
    :ok = TweetServer.add_sink(tweet_server, sink_node)
    TweetServer.handle_in(tweet_server, {:event, :foo})
    assert [{:event, :foo}] = CollectorServer.events(sink_node.server)
  end
end
