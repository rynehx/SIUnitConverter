require_relative '../../lib/query_parser'

class UnitsController < ApplicationController
  include QueryParser

  def get
    begin
      unit_name, multiplication_factor = parse_query(params["units"])
      render :json => { "unit_name" => unit_name, "multiplication_factor" => multiplication_factor.round(14) }.to_json
    rescue
      render :json => { "error" => "please input valid units and formulation" }.to_json
    end
  end
end
