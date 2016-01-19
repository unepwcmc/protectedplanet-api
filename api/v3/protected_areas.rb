require 'models/protected_area'

class API::V3::ProtectedAreas < Grape::API
  include Grape::Kaminari

  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  get "/protected_areas", rabl: "v3/views/protected_areas" do
    collection = ProtectedArea
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry = params[:with_geometry]
    @protected_areas = paginate(collection)
  end

  params { optional :with_geometry, default: true, type: Boolean }
  get "/protected_areas/:wdpa_id", rabl: "v3/views/protected_area" do
    @with_geometry = params[:with_geometry]
    @protected_area = ProtectedArea.find_by_wdpa_id(
      params[:wdpa_id]
    ) or error!(:not_found, 404)
  end
end
