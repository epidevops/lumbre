ActiveAdmin.register Product do
  # ... existing code ...

  config.sort_order = "category_asc, position_desc"

  collection_action :update_positions, method: :post do
    positions = JSON.parse(request.body.read)["positions"]

    positions.each do |position|
      product = Product.find(position["id"])
      product.update(position: position["position"])
    end

    head :ok
  end

  # ... rest of the existing code ...
end
