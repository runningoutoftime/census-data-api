class CodeBasedStatisticalArea < ApplicationRecord
  has_many :cbsa_data_fields, dependent: :destroy
  accepts_nested_attributes_for :cbsa_data_fields
end
