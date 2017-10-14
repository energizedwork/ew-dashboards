defmodule HavenPowerTest do
  use ExUnit.Case
  doctest HavenPower

  test "greets the world" do
    assert HavenPower.hello() == :world
  end
end
