defmodule PentoWeb.RatingLive.Index do
  @moduledoc false
  use Phoenix.Component
  import Phoenix.HTML
  alias PentoWeb.RatingLive

  attr :products, :list, required: true
  attr :current_user, :any, required: true

  def product_list(assigns) do
    ~H"""
    <.heading products={@products} />
    <div class="grid grid-cols-2 gap-4 divide-y">
      <.product_rating
        :for={{p, i} <- Enum.with_index(@products)}
        current_user={@current_user}
        product={p}
        index={i}
      />
    </div>
    """
  end

  attr :products, :list, required: true

  def heading(assigns) do
    ~H"""
    <h2 class="font-medium text-2xl">
      Ratings <%= if ratings_complete?(@products), do: raw("&#x2713;") %>
    </h2>
    """
  end

  def product_rating(assigns) do
    ~H"""
    <div><%= @product.name %></div>
    <%= if rating = List.first(@product.ratings) do %>
      <RatingLive.Show.stars rating={rating} product={@product} />
    <% else %>
      <div>
        <.live_component
          module={RatingLive.Form}
          id={"rating-form-#{@product.id}"}
          product={@product}
          product_index={@index}
          current_user={@current_user}
        />
      </div>
    <% end %>
    """
  end

  defp ratings_complete?(products) do
    Enum.all?(products, &(not Enum.empty?(&1.ratings)))
  end
end
