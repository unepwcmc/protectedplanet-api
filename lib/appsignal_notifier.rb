module AppsignalNotifier
  module_function

  def report_error(error, namespace:, action:, tags: {})
    return unless defined?(Appsignal) && Appsignal.active?

    Appsignal.report_error(error) do
      Appsignal.set_namespace(namespace)
      Appsignal.set_action(action)
      Appsignal.add_tags(tags) unless tags.empty?
    end
  end
end
