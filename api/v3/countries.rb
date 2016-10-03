require 'models/country'

class API::V3::Countries < Grape::API
  include Grape::Kaminari

  # == annotations
  ################
  desc "Get all countries, paginated."
  paginate per_page: 25, max_per_page: 50
  params { optional :with_geometry, default: false, type: Boolean }
  # == body
  #########
  get rabl: "v3/views/countries" do
    collection = Country
    collection = collection.without_geometry unless params[:with_geometry]

    @with_geometry = params[:with_geometry]
    @countries = paginate(collection)
  end

  # == annotations
  ################
  desc "Get one country, with geometry, given a ISO3 code"
  params { optional :with_geometry, default: true, type: Boolean }
  # == body
  #########
  get ":iso_3", rabl: "v3/views/country" do
    @with_geometry = params[:with_geometry]

    if params[:iso_3].length == 2
      @country = Country.find_by_iso(params[:iso_3].upcase) or error!(:not_found, 404)
    else
      @country = Country.find_by_iso_3(params[:iso_3].upcase) or error!(:not_found, 404)
    end
  end
end

