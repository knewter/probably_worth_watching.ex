defmodule ProbablyWorthWatching.TweetServer do
  use GenServer

  defmodule State do
    defstruct term: nil, sinks: []
  end

  ## Public API
  def start(term) do
    GenServer.start(__MODULE__, [term])
  end

  def handle_in(node, {:event, event}) do
    GenServer.call(node, {:event, event})
  end

  def add_sink(node, sink) do
    GenServer.call(node, {:add_sink, sink})
  end

  ## Server API
  def init([term]) do
    spawn(fn() ->
      ExTwitter.stream_filter(track: term)
      |> Stream.map(fn(tweet) -> __MODULE__.handle_in(self, {:event, tweet}) end)
    end)
    {:ok, %State{term: term}}
  end

  def handle_call({:event, tweet}, _from, state) do
    for sink <- state.sinks do
      ProbablyWorthWatching.Node.handle_in(sink, {:event, tweet})
    end
    {:reply, :ok, state}
  end
  def handle_call({:add_sink, sink}, _from, state) do
    {:reply, :ok, %State{state | sinks: [sink | state.sinks]}}
  end
end
