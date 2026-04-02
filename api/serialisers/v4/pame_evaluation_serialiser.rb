module API
  module Serialisers
    module V4
      module PameEvaluationSerialiser
        module_function

        def many(evaluations)
          evaluations.map { |evaluation| one(evaluation) }
        end

        def one(evaluation)
          {
            "asmt_id" => safe_value(evaluation, :asmt_id, -> { evaluation.id }),
            "id" => safe_value(evaluation, :asmt_id, -> { evaluation.id }), # Alias to asmt_id. It will be removed in next version (v5), use asmt_id.
            "eff_metaid" => safe_value(evaluation, :eff_metaid),
            "metadata_id" => safe_value(evaluation, :eff_metaid), # Alias to eff_metaid. It will be removed in next version (v5), use eff_metaid.
            "asmt_year" => safe_value(evaluation, :asmt_year, -> { safe_value(evaluation, :year) }),
            "year" => safe_value(evaluation, :asmt_year, -> { safe_value(evaluation, :year) }), # Alias to asmt_year. It will be removed in next version (v5), use asmt_year.
            "method" => safe_value(evaluation, :method),
            "methodology" => safe_value(evaluation, :method), # Alias to method. It will be removed in next version (v5), use method.
            "asmt_url" => safe_value(evaluation, :asmt_url, -> { safe_value(evaluation, :url) }),
            "url" => safe_value(evaluation, :asmt_url, -> { safe_value(evaluation, :url) }), # Alias to asmt_url. It will be removed in next version (v5), use asmt_url.
            "submit_year" => safe_value(evaluation, :submit_year),
            "verif_eff" => safe_value(evaluation, :verif_eff),
            "info_url" => safe_value(evaluation, :info_url),
            "gov_act" => safe_value(evaluation, :gov_act),
            "gov_asmt" => safe_value(evaluation, :gov_asmt),
            "dp_bio" => safe_value(evaluation, :dp_bio),
            "dp_other" => safe_value(evaluation, :dp_other),
            "mgmt_obset" => safe_value(evaluation, :mgmt_obset),
            "mgmt_obman" => safe_value(evaluation, :mgmt_obman),
            "mgmt_adapt" => safe_value(evaluation, :mgmt_adapt),
            "mgmt_staff" => safe_value(evaluation, :mgmt_staff),
            "mgmt_budgt" => safe_value(evaluation, :mgmt_budgt),
            "mgmt_thrts" => safe_value(evaluation, :mgmt_thrts),
            "mgmt_mon" => safe_value(evaluation, :mgmt_mon),
            "out_bio" => safe_value(evaluation, :out_bio),
            "source" => source_payload(evaluation.pame_source),
            "pame_method" => pame_method_payload(evaluation.pame_method)
          }
        end

        def source_payload(source)
          return nil unless source

          {
            "id" => source.id,
            "data_title" => safe_value(source, :data_title),
            "resp_party" => safe_value(source, :resp_party),
            "year" => safe_value(source, :year),
            "language" => safe_value(source, :language)
          }
        end

        def pame_method_payload(pame_method)
          return nil unless pame_method

          {
            "id" => pame_method.id,
            "name" => safe_value(pame_method, :name)
          }
        end

        def safe_value(record, method_name, fallback = nil)
          return record.public_send(method_name) if record.respond_to?(method_name)
          return fallback.call if fallback.respond_to?(:call)

          fallback
        end
      end
    end
  end
end
