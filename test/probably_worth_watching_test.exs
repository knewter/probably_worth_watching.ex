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

  test "the network" do
    count_7d_elixir = Node.new
    count_7d_ruby = Node.new
    count_7d_javascript = Node.new
    count_7d_has_link = Node.new
    count_7d_has_video = Node.new
    count_7d_decorate_video = Node.new

    decorate_video = Node.new
    decorate_video = Node.add_sink(decorate_video, count_7d_decorate_video)

    has_video = Node.new
    has_video = Node.add_sink(has_video, decorate_video)
    has_video = Node.add_sink(has_video, count_7d_has_video)

    has_link = Node.new
    has_link = Node.add_sink(has_link, has_video)
    has_link = Node.add_sink(has_link, count_7d_has_link)

    tweets_elixir = Node.new
    tweets_elixir = Node.add_sink(tweets_elixir, has_link)
    tweets_elixir = Node.add_sink(tweets_elixir, count_7d_elixir)

    tweets_ruby = Node.new
    tweets_ruby = Node.add_sink(tweets_ruby, has_link)
    tweets_ruby = Node.add_sink(tweets_ruby, count_7d_ruby)

    tweets_javascript = Node.new
    tweets_javascript = Node.add_sink(tweets_javascript, has_link)
    tweets_javascript = Node.add_sink(tweets_javascript, count_7d_javascript)
  end
end
