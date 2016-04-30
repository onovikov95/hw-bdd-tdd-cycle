require 'rails_helper'

def fake_movie
  {:title =>"fake", :director => "person", :rating => "G"}
end

describe MoviesController, type: :controller do
  describe 'create movies' do
    it 'should create a movie' do
      expect {post :create, :movie => fake_movie}.to change(Movie, :count).by(1)
    end
    it 'should redirect to the home page' do
      post :create, {:movie => fake_movie}
      expect(response).to redirect_to(:controller => 'movies', :action => 'index')
    end
  end
  describe 'search by director' do
    context 'movie has director' do
      it 'should call the relevent model method' do
        fake_results = [double('movie2'), double('movie3')]
        fake_subject = double('movie1', :director => 'a director', :title => 'a title')
        
        Movie.stub(:find).and_return(fake_subject)
        
        Movie.should_receive(:find_similar_director).with('a director').and_return(fake_results)
        get :similar_director, {:id => 1}
      end
      it 'should select the similar director view for rendering' do
        fake_results = [double('movie2'), double('movie3')]
        fake_subject = double('movie1', :director => 'a director', :title => 'a title')
        
        Movie.stub(:find).and_return(fake_subject)
        Movie.stub(:find_similar_director).and_return(fake_results)
        
        get :similar_director, {:id => 1}
        expect(response).to render_template('similar_director')
      end
    end
    context 'movie does not have director' do
      it 'should redirect to the home page' do
        fake_subject = double('movie1', :director => '', :title => 'a title')
        
        Movie.stub(:find).and_return(fake_subject)
        
        get :similar_director, {:id => 1}
        expect(response).to redirect_to(:controller => 'movies', :action => 'index')
      end
    end
  end
end
