Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/import_tool' => 'code_based_statistical_areas#import_tool'
  post '/import' => 'code_based_statistical_areas#import', :format => :js
  get '/look_up' =>  'code_based_statistical_areas#census_data_api', :format => :json
end
