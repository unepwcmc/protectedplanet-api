require 'models/protected_area'

class API::V3::ProtectedAreas < Grape::API
  include Grape::Kaminari

  #
  # == annotations
  desc "Get all protected areas, paginated."
  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  # annotations ==
  #
  get rabl: "v3/views/protected_areas" do
    collection = ProtectedArea
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry   = params[:with_geometry]
    @protected_areas = paginate(collection)
  end

  #
  # == annotations
  desc "Search for a subset of protected areas."
  paginate per_page: 25, max_per_page: 50
  params do
    optional :country, type: String, regexp: /[a-zA-Z]{3}/
    optional :marine, type: Boolean
  end
  # annotations ==
  #
  get :search, rabl: "v3/views/protected_areas" do
    collection = ProtectedArea.search(declared(params, include_missing: false))
    @protected_areas = paginate(collection)
  end

  #
  # == annotations
  desc "Get a protected area via its wdpa_id."
  params { optional :with_geometry, default: true, type: Boolean }
  # annotations ==
  #
  get ":wdpa_id", rabl: "v3/views/protected_area" do
    @with_geometry = params[:with_geometry]
    @protected_area = ProtectedArea.find_by_wdpa_id(
      params[:wdpa_id]
    ) or error!(:not_found, 404)
  end
end
