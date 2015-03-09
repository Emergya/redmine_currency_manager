Redmine::Plugin.register :redmine_currency_manager do
  name 'Currency Manager'
  author 'Emergya'
  description 'This plugin allows to manage different currency in Redmine tickets.'
  version '0.0.1'

  permission :currency_manager, { :currency_ranges => [:show] }

  settings :default => {}, :partial => 'settings/currency_settings'
  menu  :admin_menu, :cc, { :controller => 'currency_ranges', :action => 'show'},
  		:html => { :class => 'issue_statuses' }, 
  		:caption => :"currency.label_currency_ranges"
end
