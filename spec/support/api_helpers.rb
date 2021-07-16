module ApiHelpers    #ovo sam ja sam definirao.
  def json
    JSON.parse(response.body).deep_symbolize_keys
  end

  def json_data
    json[:data]
  end
end


# da bi ovaj ApiHelpers module bio accessible za testiranje, moram ga omogućiti u rails_helper.rb fajlu
