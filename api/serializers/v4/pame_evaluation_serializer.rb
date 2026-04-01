module API
  module Serializers
    module V4
      module PameEvaluationSerializer
        module_function

        def many(evaluations)
          evaluations.map { |evaluation| one(evaluation) }
        end

        def one(evaluation)
          {
            "id" => evaluation.id,
            "eff_metaid" => safe_value(evaluation, :eff_metaid),
            "url" => safe_value(evaluation, :url),
            "year" => safe_value(evaluation, :year),
            "method" => safe_value(evaluation, :method),
            "source" => source_payload(evaluation.pame_source),
            "pame_method" => pame_method_payload(evaluation.pame_method)
          }
        end

        def source_payload(source)
          return nil unless source

          {
            "eff_metaid" => source.id,
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

        def safe_value(record, method_name)
          record.respond_to?(method_name) ? record.public_send(method_name) : nil
        end
      end
    end
  end
end
