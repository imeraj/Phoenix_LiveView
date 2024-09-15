defmodule Pento.Fixtures do
  @moduledoc false
  alias Pento.{Accounts, Survey, Catalog}

  @create_product_attrs %{
    description: "test description",
    name: "Test Game",
    sku: 42,
    unit_price: 120.5
  }
  @create_user_attrs %{
    email: "test@test.com",
    password: "passwordpassword"
  }

  @create_demographic_attrs %{
    gender: "female",
    year_of_birth: DateTime.utc_now().year - 15
  }

  def product_fixture do
    {:ok, product} = Catalog.create_product(@create_product_attrs)
    product
  end

  def user_fixture(attrs \\ @create_user_attrs) do
    {:ok, user} = Accounts.register_user(attrs)
    user
  end

  def demographic_fixture(user, attrs \\ @create_demographic_attrs) do
    attrs =
      attrs
      |> Map.merge(%{user_id: user.id})

    {:ok, demographic} = Survey.create_demographic(attrs)
    demographic
  end

  def rating_fixture(stars, user, product) do
    {:ok, rating} =
      Survey.create_rating(%{
        stars: stars,
        user_id: user.id,
        product_id: product.id
      })

    rating
  end

  def create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  def create_user(_) do
    user = user_fixture()
    %{user: user}
  end

  def create_rating(stars, user, product) do
    rating = rating_fixture(stars, user, product)
    %{rating: rating}
  end

  def create_demographic(user) do
    demographic = demographic_fixture(user)
    %{demographic: demographic}
  end

  def create_socket(_) do
    %{socket: %Phoenix.LiveView.Socket{}}
  end
end
