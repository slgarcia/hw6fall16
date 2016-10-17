require 'spec_helper'


describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect( Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
      it 'should return an empty array if TMDB search does not yield any results' do
        expect(Tmdb::Movie).to receive(:find).with('fdsa').and_return(nil)
        search_result=Movie.find_in_tmdb('fdsa')
        expect(search_result).to eq([])
      end
      it 'should assign the attributes correctly' do
        new_movie = double('Movie')
        
      end
      it 'should return an array of hashes' do
        
        test_movie = [Tmdb::Movie.new({id: 1234, title: 'Inception', release_date: "2011-04-21"})]
        #movie_hash_array = [ {:tmdb_id=>1234, :title=>'Inception', :release_date=>"2011-04-21", :rating=>"G"} ]
        expect(Tmdb::Movie).to receive(:find).with('Inception').and_return(test_movie)
        allow(Movie).to receive(:get_rating).with(1234).and_return('G')
        test_result = Movie.find_in_tmdb('Inception')[0]
        
        expect(test_result[:tmdb_id]).to eq(1234)
        expect(test_result[:title]).to eq('Inception')
        expect(test_result[:release_date]).to eq("2011-04-21")
        expect(test_result[:rating]).to eq('G')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'getting rating from a movie' do
    context 'with a valid movie id' do
      
    end
  end
end