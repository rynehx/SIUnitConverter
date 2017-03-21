class SiUnit < ActiveRecord::Base
  def self.getSIUnit(unit)
    SiUnit.where("other_unit=?", unit).first
  end
end
