defmodule PentoWeb.Admin.SurveyResultsLiveTest do
  use PentoWeb.ConnCase
  alias PentoWeb.Admin.SurveyResultsLive
  import Pento.Fixtures

  @create_user2_attrs %{
    email: "another-person@email.com",
    password: "passwordpassword"
  }
  @create_demographic2_attrs %{
    gender: "male",
    year_of_birth: DateTime.utc_now().year - 30
  }

  describe "Socket state" do
    setup [
      :create_user,
      :create_product,
      :create_socket,
      :register_and_log_in_user
    ]

    setup %{user: user} do
      create_demographic(user)
      user2 = user_fixture(@create_user2_attrs)
      demographic_fixture(user2, @create_demographic2_attrs)
      [user2: user2]
    end

    test "no ratings exist", ctx do
      %{socket: socket} = ctx
      {:ok, socket} = SurveyResultsLive.update(socket.assigns, socket)

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 0}]
    end

    test "ratings exists", ctx do
      %{socket: socket, product: product, user: user} = ctx
      create_rating(2, user, product)
      {:ok, socket} = SurveyResultsLive.update(socket.assigns, socket)

      assert socket.assigns.products_with_average_ratings == [{"Test Game", 2.0}]
    end

    test "ratings are filtered by age group", ctx do
      %{socket: socket, product: product, user: user, user2: user2} = ctx
      create_rating(2, user, product)
      create_rating(3, user2, product)

      {:ok, socket} = SurveyResultsLive.update(socket.assigns, socket)
      assert socket.assigns.age_group_filter == "all"

      socket = update_socket(socket, :age_group_filter, "18 and under")
      {:ok, socket} = SurveyResultsLive.update(socket.assigns, socket)

      assert socket.assigns.age_group_filter == "18 and under"
    end
  end

  defp update_socket(socket, key, value) do
    %{socket | assigns: Map.merge(socket.assigns, Map.new([{key, value}]))}
  end
end
