require 'models/protected_area'

class API::V3::ProtectedAreas < Grape::API
  include Grape::Kaminari

  desc "Get all protected areas, paginated."
  params do
    optional :with_geometry, default: false, type: Boolean
  end
  paginate per_page: 25, max_per_page: 50
  get rabl: "v3/views/protected_areas" do
    collection = ProtectedArea
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry   = params[:with_geometry]
    @protected_areas = paginate(collection)
  end

  desc "Search for a subset of protected areas."
  get :search do
  end

  desc "Get a protected area via its wdpa_id."
  params do
    optional :with_geometry, default: true, type: Boolean
  end
  get ":wdpa_id", rabl: "v3/views/protected_area" do
    @with_geometry = params[:with_geometry]
    @protected_area = ProtectedArea.find_by_wdpa_id(
      params[:wdpa_id]
    ) or error!(:not_found, 404)
  end
end
