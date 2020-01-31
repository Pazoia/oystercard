require 'journey'

describe Journey do

  journey = Journey.new("start_st", "end_st")

  it 'saves entry_station name' do
    expect(journey.entry_station).to eq("start_st")
  end
  
  it 'saves exit_station name' do
    expect(journey.exit_station).to eq("end_st")
  end
end
