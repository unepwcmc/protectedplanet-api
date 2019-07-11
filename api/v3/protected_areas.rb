require 'models/protected_area'

class API::V3::ProtectedAreas < Grape::API
  include Grape::Kaminari

  before do
    authenticate!
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error! e, 400
  end

  # == annotations
  ################
  desc "Get all protected areas, paginated."
  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  # == body
  #########
  get rabl: "v3/views/protected_areas" do
    collection = ProtectedArea
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry   = params[:with_geometry]
    @protected_areas = paginate(collection)
  end

  # == annotations
  ################
  desc "Search for a subset of protected areas."
  paginate per_page: 25, max_per_page: 50
  params do
    optional :country, type: String, regexp: /[a-zA-Z]{3}/
    optional :marine, type: Boolean
    optional :is_green_list, type: Boolean
    optional :designation, type: Integer
    optional :jurisdiction, type: Integer
    optional :governance, type: Integer
    optional :iucn_category, type: Integer
    optional :with_geometry, default: false, type: Boolean
    at_least_one_of :country, :marine, :is_green_list, :designation,
      :jurisdiction, :governance, :iucn_category
  end
  # == body
  #########
  get :search, rabl: "v3/views/protected_areas" do
    collection = ProtectedArea.search(declared(params, include_missing: false))

    @with_geometry   = params[:with_geometry]
    @protected_areas = paginate(collection)
  end

  # == annotations
  ################
  desc "Get ACP countries protected areas."
  params { optional :with_geometry, default: false, type: Boolean }
  # == body
  #########
  get :biopama, rabl: "v3/views/protected_areas" do
    collection = ProtectedArea.biopama.with_pame_evaluations
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry   = params[:with_geometry]
    @protected_areas = collection
  end

  # == annotations
  ################
  desc "Get a protected area via its wdpa_id."
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ":wdpa_id", rabl: "v3/views/protected_area" do
    @with_geometry = params[:with_geometry]
    @protected_area = ProtectedArea.find_by_wdpa_id(
      params[:wdpa_id]
    ) or error!(:not_found, 404)
  end
end
