require 'models/protected_area_parcel'

class API::V4::ProtectedAreaParcels < Grape::API
  helpers API::Helpers

  before do
    authenticate!
  end

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error! e, 400
  end

  # == annotations
  ################
  desc 'Get all protected area parcels, paginated.'
  params do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 25, values: 1..50
    optional :with_geometry, default: false, type: Boolean
  end
  # == body
  #########
  get do
    collection = ProtectedAreaParcel
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serialisers::V4::ProtectedAreaParcelSerializer.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Search for a subset of protected area parcels.'
  params do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 25, values: 1..50
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
  get :search do
    collection = ProtectedAreaParcel.search(declared(params, include_missing: false))
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serialisers::V4::ProtectedAreaParcelSerializer.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Get parcels of a protected area via its site_id.'
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ':site_id' do
    collection = ProtectedAreaParcel.where(site_id: params[:site_id])
    collection = collection.without_geometry unless params[:with_geometry]
    error!(:not_found, 404) if collection.empty?

    API::Serialisers::V4::ProtectedAreaParcelSerializer.collection(
      collection,
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end

  # == annotations
  ################
  desc 'Get a protected area parcel via its site_id and site_pid.'
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ':site_id/:site_pid' do
    protected_area_parcel = ProtectedAreaParcel.find_by(
      site_id: params[:site_id],
      site_pid: params[:site_pid]
    )
    error!(:not_found, 404) unless protected_area_parcel

    API::Serialisers::V4::ProtectedAreaParcelSerializer.single(
      protected_area_parcel,
      current_user: current_user,
      with_geometry: params[:with_geometry]
    )
  end
end
