require 'models/protected_area'

class API::V3::ProtectedAreas < Grape::API
  helpers API::Helpers

  after do
    set_v3_deprecation_headers
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error! e, 400
  end

  # == annotations
  ################
  desc 'Get all protected areas, paginated.'
  params do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 25, values: 1..50
    optional :with_geometry, default: false, type: Boolean
  end
  # == body
  #########
  get do
    collection = ProtectedArea.with_api_json_includes
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serialisers::V3::ProtectedAreaSerialiser.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Search for a subset of protected areas.'
  params do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 25, values: 1..50
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
  get :search do
    collection = ProtectedArea.search(declared(params, include_missing: false))

    API::Serialisers::V3::ProtectedAreaSerialiser.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Get ACP countries protected areas.'
  params { optional :with_geometry, default: false, type: Boolean }
  # == body
  #########
  get :biopama do
    collection = ProtectedArea.with_api_json_includes.biopama.with_pame_evaluations
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serialisers::V3::ProtectedAreaSerialiser.collection(
      collection,
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Get a protected area via its wdpa_id (site_id).'
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ':wdpa_id' do
    protected_area = ProtectedArea.with_api_json_includes.find_by_site_id(params[:wdpa_id])
    error!(:not_found, 404) unless protected_area

    API::Serialisers::V3::ProtectedAreaSerialiser.single(
      protected_area,
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end
end
