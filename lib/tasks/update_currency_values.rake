desc 'Update range currency conversion values from SAP database'

task :update_currency_values => :environment do
	currencies = CurrencyRange.get_currencies

	currencies.each do |currency|
		sap_value = SapConnection.get_value(currency, Date.today)

		CurrencyRange.set_current_value(currency,sap_value) if sap_value.present?
	end

	ranges = CurrencyRange.get_ranges

	ranges.each do |range|
		sap_value = SapConnection.get_value(range[:currency], range[:due_date])

		range.set_value(sap_value) if sap_value.present?
	end
end