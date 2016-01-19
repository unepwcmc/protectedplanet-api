require 'models/country'

class API::V3::Countries < Grape::API
  include Grape::Kaminari

  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  get "/countries", rabl: "v3/views/countries" do
    collection = Country
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry = params[:with_geometry]
    @countries = paginate(collection)
  end

  params { optional :with_geometry, default: true, type: Boolean }
  get "/countries/:iso_3", rabl: "v3/views/country" do
    @with_geometry = params[:with_geometry]
    @country = Country.find_by_iso_3(
      params[:iso_3]
    ) or error!(:not_found, 404)
  end
end

