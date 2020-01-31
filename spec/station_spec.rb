require 'station'

describe Station do

  station = Station.new("Aldgate", 1)

  it 'stores station name' do
    expect(station.name).to eq("Aldgate")
  end

  it 'stores zone' do
    expect(station.zone).to eq(1)
  end
end
