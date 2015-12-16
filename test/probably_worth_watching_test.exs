defmodule ProbablyWorthWatching do
  defmodule Node do
    defstruct sinks: []

    def new do
      %__MODULE__{}
    end

    def add_sink(node, sink) do
      %__MODULE__{node | sinks: [sink | node.sinks]}
    end
  end
end

defmodule ProbablyWorthWatchingTest do
  use ExUnit.Case
  alias ProbablyWorthWatching.Node

  test "the first node" do
    elixir_tweets =
      Node.new
      |> Node.add_sink(Node.new)
      |> Node.add_sink(Node.new)

    assert %Node{} = elixir_tweets
    assert length(elixir_tweets.sinks) == 2
  end
end
