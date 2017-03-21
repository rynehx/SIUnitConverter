require 'bigdecimal'
pi = BigDecimal.new("3.1415926535897932384626433832795028841971693993751058209749445923078164")


converstion_table = [
  ["s", "min", 60],
  ["s", "h", 3600],
  ["s", "d", 86400],
  ["s", "day", 86400],
  ["s", "hour", 3600],
  ["s", "minute", 60],
  ["rad", "degree", pi/180],
  ["rad", "deg", pi/180],
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
