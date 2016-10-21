class Governance < ActiveRecord::Base
  has_many :protected_areas

  GOVERNANCE_TYPES = {
    "Governance by Government" => [
      "Federal or national ministry or agency",
      "Sub-national ministry or agency",
      "Government-delegated management"
    ],
    "Shared Governance" => [
      "Transboundary governance",
      "Collaborative governance",
      "Joint governance"
    ],
    "Private Governance" => [
      "Individual landowners",
      "Non-profit organisations",
      "For-profit organisations"
    ],
    "Governance by Indigenous Peoples and Local Communities" => [
      "Indigenous peoples",
      "Local communities"
    ]
  }
  def governance_type
    GOVERNANCE_TYPES.each do |k,v|
      return k if v.include?(name)
    end

    return nil
  end
end
