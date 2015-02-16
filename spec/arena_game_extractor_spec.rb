require_relative '../lib/arena_game_extractor'

describe ArenaGameExtractor do

  describe '#games' do
    let(:timestamps) { [2, 3, 4, 5, 10, 11, 12] }
    it 'determines game start and stop times' do
      games = ArenaGameExtractor.new(timestamps).games
      expect(games.first.start).to eq(5)
      expect(games.first.finish).to eq(10)
    end

    describe "when there's no ending load screen" do
      it 'determines game start and stop times' do
        games = ArenaGameExtractor.new([1, 2, 4, 5, 7, 8]).games
        expect(games.first.start).to eq(2)
        expect(games.first.finish).to eq(4)
        expect(games.length).to eq(1)
      end
    end

    describe "with 1 second loading screens" do
      let(:timestamps) { [2, 4, 6, 8] }
      it 'determines game start and stop times' do
        games = ArenaGameExtractor.new(timestamps).games
        expect(games[0].start).to eq(2)
        expect(games[0].finish).to eq(4)
        expect(games[1].start).to eq(6)
        expect(games[1].finish).to eq(8)
      end
    end

    describe "with 2 second loading screens" do
      let(:timestamps) { [2, 3, 5, 6, 8, 9, 11, 12] }
      it 'determines game start and stop times' do
        games = ArenaGameExtractor.new(timestamps).games
        expect(games[0].start).to eq(3)
        expect(games[0].finish).to eq(5)
        expect(games[1].start).to eq(9)
        expect(games[1].finish).to eq(11)
      end
    end
  end
end
