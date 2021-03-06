module Web; end
require "web/helpers"
require "lib/admin_csv_generator"

class Web::AdminController < Sinatra::Base
  helpers Web::Helpers
  set :views, File.join(settings.root, '../views')

  get("/admin") do
    protected!
    erb :admin, layout: :layout
  end

  get("/admin/archived") do
    protected!
    erb :archived, layout: :layout
  end

  get("/admin/export") do
    content_type "application/octet-stream"
    attachment "pp_api_users.csv"

    AdminCsvGenerator.generate
  end

  post("/admin/api_users/:id") do
    protected!
    user = ApiUser.find(params[:id])

    if params.has_key?("destroy")
      user.destroy
    elsif params.has_key?("save")
      update_user(user, params["api_user"])
      user.save
    end

    Appsignal.set_gauge("user_count",        ApiUser.count)
    Appsignal.set_gauge("active_user_count", ApiUser.where(active: true).count)

    redirect back
  end

  get("/admin/sign_out") do
    protected!
    session.destroy

    redirect "/"
  end

  private

  def update_user user, params
    if params["active"].present?
      unless user.active
        user.activate!

        documentation_url = url("/documentation")
        Mailer.send_new_activation_notification(user, documentation_url)
      end
    else
      user.deactivate!
    end

    user.archived = params["archived"].present?

    params["permissions"].each do |(api_object, attrs)|
      user.permissions[api_object] = attrs.keys
    end
  end
end
