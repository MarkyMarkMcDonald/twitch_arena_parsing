require 'json'

describe 'When I use the Twitch Arena Extractor CLI' do
  it 'Prints start and finish times for a video' do
    result = `bin/twarex spec/fixtures/two-start-load-screens.mp4`
    expect($?.exitstatus).to eq(0)
    puts result
    json_result = JSON.parse(result)
    expect(json_result.first['start']).to eq(10)
    expect(json_result.first['finish']).to eq(29)
  end
end
