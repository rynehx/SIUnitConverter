require "spec_helper"
require 'bigdecimal'
require 'query_parser'
pi = BigDecimal.new("3.14159265358979323846264338327950288")

describe QueryParser do
  let(:dummy_class) { Class.new { include QueryParser }.new }
  before(:context) do
    converstion_table = [
      ["s", "min", 60],
      ["s", "h", 3600],
      ["s", "d", 86400],
      ["s", "day", 86400],
      ["s", "hour", 3600],
      ["s", "minute", 60],
      ["rad", "degree", pi/180],
      ["rad", "'", pi/10800],
      ["rad", "°", pi/180],
      ["rad", "\"", pi/648000],
      ["rad", "second", pi/648000],
      ["m²", "ha", 10000],
      ["m²", "hectare", 10000],
      ["m³", "litre", 0.001],
      ["m³", "L", 0.001],
      ["kg", "tonne", 1000],
      ["kg", "t", 1000]
    ]

    converstion_table.each do |info|
      si_unit, other_unit, conversion_factor = info
      SiUnit.create({
        si_unit: si_unit,
        other_unit: other_unit,
        conversion_factor: conversion_factor,
      })
    end
  end

  describe 'testing unit conversion to SI' do
    it "should return valid result for query without parenthesis" do
      si_query, conversion_factor = dummy_class.parse_query("t*t/min")
      expect(si_query).to eq("kg*kg/s")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("16666.66666666666667"))
    end

    it "should return valid result for unicode and esacped char" do
      si_query, conversion_factor = dummy_class.parse_query("(°/degree*\"/second)")
      expect(si_query).to eq("(rad/rad*rad/rad)")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("1.0"))
    end

    it "should return valid result for query with only parenthesis" do
      si_query, conversion_factor = dummy_class.parse_query("((((((((((t*t))))))))))")
      expect(si_query).to eq("((((((((((kg*kg))))))))))")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("1000000.0"))
    end

    it "should return valid result for query with only parenthesis" do
      si_query, conversion_factor = dummy_class.parse_query("((((((((((t*t))))))))))")
      expect(si_query).to eq("((((((((((kg*kg))))))))))")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("1000000.0"))
    end

    it "should return valid result for query with single depth parenthesis" do
      si_query, conversion_factor = dummy_class.parse_query("(t*t)/(min/ha)")
      expect(si_query).to eq("(kg*kg)/(s/m²)")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("166666666.66666666666667"))
    end

    it "should return valid result for query with multi depth parenthesis" do
      si_query, conversion_factor = dummy_class.parse_query("(t*t)/(min/(ha*ha/(d*litre)))*h")
      expect(si_query).to eq("(kg*kg)/(s/(m²*m²/(s*m³)))*s")
      expect(conversion_factor.round(14)).to eq(BigDecimal.new("69444444444444.44444444444444"))
    end

    it "should return valid result for query with degrees" do
      si_query, conversion_factor = dummy_class.parse_query("(\")/((degree)*(°*second))/'")
      expect(si_query).to eq("(rad)/((rad)*(rad*rad))/rad")
      minute = pi/10800
      degree = pi/180
      second = pi/648000
      res = (second)/((degree)*(degree*second))/minute

      expect(conversion_factor.round(14)).to eq(res.round(14))
    end
  end
end
