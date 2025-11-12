require 'models/protected_area_parcel'

class API::V4::ProtectedAreaParcels < Grape::API
  include Grape::Kaminari

  before do
    authenticate!
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error! e, 400
  end

  # == annotations
  ################
  desc "Get all protected area parcels, paginated."
  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  # == body
  #########
  get rabl: "v4/views/protected_area_parcels" do
    collection = ProtectedAreaParcel
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry = params[:with_geometry]
    @protected_area_parcels = paginate(collection)
  end

  # == annotations
  ################
  desc "Search for a subset of protected area parcels."
  paginate per_page: 25, max_per_page: 50
  params do
    optional :country, type: String, regexp: /[a-zA-Z]{3}/
    optional :marine, type: Boolean
    optional :designation, type: Integer
    optional :jurisdiction, type: Integer
    optional :governance, type: Integer
    optional :iucn_category, type: Integer
    optional :with_geometry, default: false, type: Boolean
    at_least_one_of :country, :marine, :designation,
      :jurisdiction, :governance, :iucn_category
  end
  # == body
  #########
  get :search, rabl: "v4/views/protected_area_parcels" do
    collection = ProtectedAreaParcel.search(declared(params, include_missing: false))
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry = params[:with_geometry]
    @protected_area_parcels = paginate(collection)
  end

  # == annotations
  ################
  desc "Get parcels of a protected area via its site_id."
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ":site_id", rabl: "v4/views/protected_area_parcels" do
    @with_geometry = params[:with_geometry]
    collection = ProtectedAreaParcel.where(site_id: params[:site_id])
    collection = collection.without_geometry unless params[:with_geometry]
    
    @protected_area_parcels = collection
    error!(:not_found, 404) if @protected_area_parcels.empty?
  end

  # == annotations
  ################
  desc "Get a protected area parcel via its site_id and site_pid."
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ":site_id/:site_pid", rabl: "v4/views/protected_area_parcel" do
    @with_geometry = params[:with_geometry]
    @protected_area_parcel = ProtectedAreaParcel.find_by(
      site_id: params[:site_id],
      site_pid: params[:site_pid]
    ) or error!(:not_found, 404)
  end
end
