module API
  module Serialisers
    module V3
      module PameEvaluationSerialiser
        module_function

        def many(evaluations)
          evaluations.map { |evaluation| one(evaluation) }
        end

        def one(evaluation)
          {
            'id' => evaluation.id,
            'url' => safe_value(evaluation, :asmt_url),
            'metadata_id' => safe_value(evaluation, :eff_metaid),
            'methodology' => safe_value(evaluation, :method),
            'source' => source_payload(evaluation.pame_source)
          }
        end

        def source_payload(source)
          return nil unless source

          {
            'data_title' => safe_value(source, :data_title),
            'resp_party' => safe_value(source, :resp_party),
            'year' => safe_value(source, :year),
            'language' => safe_value(source, :language)
          }
        end

        def safe_value(record, method_name)
          return record.public_send(method_name) if record.respond_to?(method_name)
          nil
        end
      end
    end
  end
end
