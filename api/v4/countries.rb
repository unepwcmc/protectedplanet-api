require 'models/country'

class API::V4::Countries < Grape::API
  helpers API::Helpers

  rescue_from Grape::Exceptions::ValidationErrors do |e|
    error! e, 400
  end

  # == annotations
  ################
  desc 'Get all countries, paginated.'
  params do
    optional :page, type: Integer, default: 1
    optional :per_page, type: Integer, default: 25, values: 1..50
    optional :with_geometry, default: false, type: Boolean
    optional :iucn_category_long_names, default: false, type: Boolean
    optional :group_governances, default: false, type: Boolean
  end
  # == body
  #########
  get do
    collection = Country.with_api_json_includes
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serialisers::V4::CountrySerialiser.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry],
      iucn_category_long_names: params[:iucn_category_long_names],
      group_governances: params[:group_governances]
    )
  end

  # == annotations
  ################
  desc 'Get one country, with geometry, given a ISO3 code'
  params do
    optional :with_geometry, default: true, type: Boolean
    optional :iucn_category_long_names, default: false, type: Boolean
    optional :group_governances, default: false, type: Boolean
  end
  # == body
  #########
  get ':iso_3' do
    scope = Country.with_api_json_includes
    country =
      if params[:iso_3].length == 2
        scope.find_by_iso(params[:iso_3].upcase)
      else
        scope.find_by_iso_3(params[:iso_3].upcase)
      end

    error!(:not_found, 404) unless country

    API::Serialisers::V4::CountrySerialiser.single(
      country,
      current_user: current_user,
      with_geometry: params[:with_geometry],
      iucn_category_long_names: params[:iucn_category_long_names],
      group_governances: params[:group_governances]
    )
  end
end
