defmodule BrothTest.Message.User.BanTest do
  use ExUnit.Case, async: true

  alias Broth.Message.User.Ban

  setup do
    {:ok, uuid: UUID.uuid4()}
  end

  describe "when you send an ban message" do
    test "it populates userId", %{uuid: uuid} do
      assert {:ok,
              %{
                payload: %Ban{userId: ^uuid, reason: "foobar"}
              }} =
               Broth.Message.validate(%{
                 "operator" => "user:ban",
                 "payload" => %{"userId" => uuid, "reason" => "foobar"},
                 "reference" => UUID.uuid4()
               })

      # short form also allowed
      assert {:ok,
              %{
                payload: %Ban{userId: ^uuid, reason: "foobar"}
              }} =
               Broth.Message.validate(%{
                 "op" => "user:ban",
                 "p" => %{"userId" => uuid, "reason" => "foobar"},
                 "ref" => UUID.uuid4()
               })
    end

    test "omitting the userId is not allowed" do
      assert {:error, %{errors: [userId: {"can't be blank", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "user:ban",
                 "payload" => %{"reason" => "foobar"},
                 "reference" => UUID.uuid4()
               })
    end

    test "omitting the reason is not allowed", %{uuid: uuid} do
      assert {:error, %{errors: [reason: {"can't be blank", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "user:ban",
                 "payload" => %{"userId" => uuid},
                 "reference" => UUID.uuid4()
               })
    end

    test "omitting the reference is not allowed", %{uuid: uuid} do
      assert {:error, %{errors: [reference: {"is required for Broth.Message.User.Ban", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "user:ban",
                 "payload" => %{"userId" => uuid, "reason" => "foobar"},
               })
    end
  end
end