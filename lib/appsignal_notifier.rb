# AppSignal 1.1 send_error does not support set_action; create the transaction explicitly.
module AppsignalNotifier
  module_function

  def report_error(error, namespace:, action:, tags: {})
    return unless defined?(Appsignal) && Appsignal.active?

    transaction = Appsignal::Transaction.create(
      SecureRandom.uuid,
      namespace,
      Appsignal::Transaction::GenericRequest.new({})
    )
    transaction.set_action(action)
    transaction.set_tags(tags) unless tags.empty?
    transaction.set_error(error)
    Appsignal::Transaction.complete_current!
  end
end
