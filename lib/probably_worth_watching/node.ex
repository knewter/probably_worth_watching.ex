defmodule ProbablyWorthWatching.Node do
  defstruct sinks: [], server: nil, module: nil

  def new do
    %__MODULE__{}
  end
  def new(mod, args) when is_list(args) do
    {:ok, pid} = mod.start(args)
    %__MODULE__{server: pid, module: mod}
  end

  def add_sink(node, sink) do
    %__MODULE__{node | sinks: [sink | node.sinks]}
  end

  def handle_in(node, event) do
    node.module.handle_in(node.server, event)
  end
end
