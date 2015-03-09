# Plugin's routes
RedmineApp::Application.routes.draw do
	match '/currency_ranges/:action' => 'currency_ranges'
	match '/currency_ranges/delete/:id' => 'currency_ranges#delete'
	#resources :currency_ranges
end
