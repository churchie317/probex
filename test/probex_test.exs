defmodule ProbexTest do
  use ExUnit.Case
  doctest Probex

  test "greets the world" do
    assert Probex.hello() == :world
  end
end
