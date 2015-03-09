class SapConnection < ActiveRecord::Base
	establish_connection :sap
	
	# Para el tipo de moneda indicado, obtiene de la BBDD de SAP el factor de conversión registrado para la fecha indicada o la anterior más cercana
	def self.get_value(currency,date)
		begin
			sap_table_name = Setting.plugin_redmine_currency_manager['sap_table_name']
			sap_currency_field = Setting.plugin_redmine_currency_manager['sap_currency_field']
			sap_value_field = Setting.plugin_redmine_currency_manager['sap_value_field']
			sap_date_field = Setting.plugin_redmine_currency_manager['sap_date_field']

			query = "SELECT "+sap_value_field+" FROM "+sap_table_name+" WHERE "+sap_currency_field+" = '"+currency+"' AND "+sap_date_field+" <= '"+date.to_date.to_s+"' ORDER BY "+sap_date_field+" DESC"

			resp = connection.select_all(query)

			if resp.blank?
				return nil
			else
				return resp[0][sap_value_field]
			end
		rescue
			return nil
		end
	end
end

