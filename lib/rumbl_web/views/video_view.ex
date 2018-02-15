defmodule RumblWeb.VideoView do
  use RumblWeb, :view

  def category_name(%{ category: category }) when is_nil(category) do
    "-"
  end

  def category_name(video) do
    video.category.name
  end
end
