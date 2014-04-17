require 'spec_helper'


describe OMDB::Gateway do
  describe "With invalid Endpoint URI",
           :vcr => {:cassette_name => "funkyfunky", :record => :new_episodes} do
    let(:gateway) { OMDB.gateway('funkyfunky') }

    it 'should have the correct API endpoint' do
      gateway.base_uri.should eq('funkyfunky')
    end

    describe 'with a movie that exists' do
      let(:title_results) do
        gateway.title_search('Star Wars')
      end

      describe "#success" do
        it 'should note failure' do
          title_results.success?.should be false
        end
      end
      describe "#error_message" do
        it 'should note failure' do
          title_results.error_message.should include "BadURIError"
        end
      end
    end
  end


  describe "With invalid Endpoint URI",
           :vcr => {:cassette_name => "lkajsdakkajsdalskjdaasddsad.com", :record => :new_episodes} do
    let(:gateway) { OMDB.gateway('http://lkajsdakkajsdalskjdaasddsad.com') }

    it 'should have the correct API endpoint' do
      gateway.base_uri.should eq('http://lkajsdakkajsdalskjdaasddsad.com')
    end

    describe 'with a movie that exists' do
      let(:title_results) do
        gateway.title_search('Star Wars')
      end

      describe "#success" do
        it 'should note failure' do
          title_results.success?.should be false
        end
      end

      describe "#error_message" do
        it 'should note failure' do
          title_results.error_message.should include "Connection Failed"
        end
      end

    end
  end


  describe "With Valid Endpoint",
           :vcr => {:cassette_name => "omdbapi.com", :record => :new_episodes} do
    let(:gateway) { OMDB.gateway }

    it 'should have the correct API endpoint' do
      gateway.base_uri.should eq(OMDB::Default::API_ENDPOINT)
    end

    describe '#title_search' do
      describe 'with a movie that exists' do
        let(:title_results) do
          gateway.title_search('Star Wars')
        end

        it 'should return a hash of movie attributes' do
          title_results.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should contain a title' do
          title_results.as_hash['Title'].should be_instance_of String
        end
      end

      describe 'with the year parameter' do
        let(:title_results1) { gateway.title_search('True Grit') }
        let(:title_results2) { gateway.title_search('True Grit', '1969') }

        it 'should not be the same title' do
          title_results1.body.should_not eq(title_results2.body)
        end
      end

      describe 'with the plot parameter' do
        let(:title_results1) { gateway.title_search('Game of Thrones') }
        let(:title_results2) { gateway.title_search('Game of Thrones', nil, 'full') }

        it 'should have different plots' do
          title_results1.as_hash['Plot'].should_not eq(title_results2.as_hash['Plot'])
        end
      end

      describe 'with a movie that doesn' 't exist' do
        let(:no_title_results) {
          gateway.title_search('lsdfoweirjrpwef323423dsfkip')
        }

        it 'should return a hash' do
          no_title_results.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should return a hash with a false response' do
          no_title_results.success?.should eq false
        end

        it 'should return a hash with an error message' do
          no_title_results.error_message.should be_instance_of String
        end
      end
    end

    describe '#find_by_id' do

      describe 'with a title that exists' do
        let(:id_lookup) {
          gateway.find_by_id('tt0411008')
        }

        it 'should return a hash of movie attributes' do
          id_lookup.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should contain a title' do
          id_lookup.as_hash['Title'].should be_instance_of String
        end
      end

      describe 'with a movie that does not exist' do
        let(:no_id_lookup) { gateway.find_by_id('tt1231230123') }

        it 'should return nil' do
          no_id_lookup.success?.should eq false
        end
      end
    end

    describe '#free_search' do

      describe 'with search results' do
        let(:results) { gateway.free_search('Star Wars') }

        it 'should return an OMDB::Gateway::ResponseWrapper' do
          results.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should return an array with hash contents' do
          results.array_first.should be_instance_of Hash
        end
      end

      describe 'with a single search result' do
        let(:result) { gateway.free_search('Star Wars: Episode VI - Return of the Jedi') }

        it 'should return an array' do
          result.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should return an array with 1 element' do
          result.as_array.length.should eq 1
        end

        it 'should have a title' do
          result.array_first['Title'].should eq('Star Wars: Episode VI - Return of the Jedi')
        end
      end

      describe 'with no search results' do
        let(:results) {
          gateway.free_search('lsdfoweirjrpwef323423dsfkip')
        }

        it 'should return an OMDB::Gateway::ResponseWrapper' do
          results.should be_instance_of OMDB::Gateway::ResponseWrapper
        end

        it 'should show app failed' do
          results.app_success?.should eq false
        end
      end
    end
  end
end