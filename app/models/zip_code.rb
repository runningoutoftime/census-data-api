class ZipCode < ApplicationRecord
  validates_numericality_of :tot_ratio, :oth_ratio, :bus_ratio, :res_ratio, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 1
end
