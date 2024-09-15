defmodule PentoWeb.Admin.DashboardLiveTest do
  use PentoWeb.ConnCase
  import Phoenix.LiveViewTest
  import Pento.Fixtures

  @create_user2_attrs %{
    email: "another-person@email.com",
    password: "passwordpassword"
  }

  @create_demographic_over_18_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 30
  }

  describe "Survey results" do
    setup [:register_and_log_in_user, :create_product, :create_user]

    setup %{user: user, product: product} do
      create_demographic(user)
      create_rating(2, user, product)
      user2 = user_fixture(@create_user2_attrs)
      create_demographic(user2, @create_demographic_over_18_attrs)

      create_rating(3, user2, product)
      :ok
    end

    test "it filters by age group", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/admin/dashboard")

      html =
        view
        |> element("#age-group-form")
        |> render_change(%{"age_group_filter" => "18 and under"})

      assert html =~ "<title>2.00</title>"
    end
  end
end
