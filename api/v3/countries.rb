require 'models/country'

class API::V3::Countries < Grape::API
  helpers API::Helpers

  after do
    set_v3_deprecation_headers
  end

  # == annotations
  ################
  desc "Get all countries, paginated."
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
    collection = Country
    collection = collection.without_geometry unless params[:with_geometry]

    API::Serializers::V3::CountrySerializer.collection(
      paginate_collection(collection),
      current_user: current_user,
      with_geometry: params[:with_geometry],
      iucn_category_long_names: params[:iucn_category_long_names],
      group_governances: params[:group_governances]
    )
  end

  # == annotations
  ################
  desc "Get one country, with geometry, given a ISO3 code"
  params {
    optional :with_geometry, default: true, type: Boolean
    optional :iucn_category_long_names, default: false, type: Boolean
    optional :group_governances, default: false, type: Boolean
  }
  # == body
  #########
  get ":iso_3" do
    country =
      if params[:iso_3].length == 2
        Country.find_by_iso(params[:iso_3].upcase)
      else
        Country.find_by_iso_3(params[:iso_3].upcase)
      end

    error!(:not_found, 404) unless country

    API::Serializers::V3::CountrySerializer.single(
      country,
      current_user: current_user,
      with_geometry: params[:with_geometry],
      iucn_category_long_names: params[:iucn_category_long_names],
      group_governances: params[:group_governances]
    )
  end
end

