class CurrencyRange < ActiveRecord::Base
	validate :avoid_overlapping

	def avoid_overlapping
		errors.add(:base, "Los intervalos no pueden solaparse") if CurrencyRange.find(:first, :conditions => ["id != ? AND currency = ? AND start_date <= ? AND due_date >= ?", self[:id] || 0, self[:currency], self[:due_date], self[:start_date]]) != nil
	end

	def get_error_message
	    error_msg = ""
	    
	    # get errors list
	    self.errors.full_messages.each do |msg|
	      if error_msg != ""
	        error_msg << "<br>"
	      end
	      error_msg << msg
	    end

	    error_msg
	end

	# Actualiza el factor de conversión actual del tipo de moneda indicado al valor indicado
	def self.set_current_value(currency, value)
		row = self.find(:first, :conditions => ["currency = ? AND start_date is NULL AND due_date is NULL", currency])

		if row.present?
			row.update_attributes({value: value})
		else
			self.create({currency: currency, value: value})
		end
	end
=begin
	def self.set_range_value(currency, date, value)
		row = self.find(:first, :conditions => ["currency = ? AND due_date <= ?", currency, date], :order => "due_date DESC")

		row.update_attributes({value: value}) if row.present?
	end
=end

	# Devuelve un array con los tipos de moneda registrados
	def self.get_currencies
		self.select(:currency).map(&:currency).uniq
	end

	# Devuelve los rangos registrados (no incluye los factores de conversión actuales de tipos de moneda)
	def self.get_ranges
		self.find(:all, :conditions => ["start_date IS NOT NULL AND due_date IS NOT NULL"], :order => "currency, due_date ASC")
	end

	# Establece un factor de conversión para un rango
	def set_value(value)
		self.update_attributes({value: value})
	end



	# Devuelve el factor de conversión actual del tipo de moneda indicado
	def self.get_current(currency)
		self.find(:first, :select => "value", :conditions => ["currency = ? AND start_date is NULL AND due_date is NULL", currency])[:value]
	end

	# Devuelve el rango efectivo para una determinada fecha del tipo de moneda indicado
	def self.get_range(currency, date)
		self.find(:first, :conditions => ["currency = ? AND start_date <= ?", currency, date.to_date.beginning_of_day], :order => "due_date DESC")
	end
end