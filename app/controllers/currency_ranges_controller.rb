class CurrencyRangesController < ApplicationController
  unloadable

  before_filter :authorize_global, :only => [:show]
  
  # Página principal del panel de control de intervalos
  def show
  	@ranges = CurrencyRange.get_ranges #find(:all, :conditions => ["start_date IS NOT NULL AND due_date IS NOT NULL"])
    @current_values = CurrencyRange.find(:all, :conditions => ["start_date IS NULL AND due_date IS NULL"])

    if Setting.plugin_redmine_currency_manager['currency_custom_field'].present?
      @currency_options = CustomField.find(Setting.plugin_redmine_currency_manager['currency_custom_field']).possible_values
    else
      @currency_options = []
    end
  end

  # Crear nuevo intervalo
  def add
  	data = params[:currency_range]

  	@range = CurrencyRange.new(data)

    sap_value = SapConnection.get_value(@range[:currency], data[:due_date])

    if sap_value.present?
      @range[:value] = sap_value
    else
      @range[:value] = 0.0
      flash[:warning] = l(:"currency.text_no_values_found_sap")
    end

  	if @range.save
  		flash[:notice] = l(:"currency.text_range_create_success") 
    else
  		flash[:error] = @range.get_error_message
    end

    redirect_to action: "show"
  end

  # Actualizar intervalo
  def update
  	data = params[:currency_range]

  	@range = CurrencyRange.find_by_id(data[:id])

  	sap_value = SapConnection.get_value(@range[:currency], data[:due_date])

    if sap_value.present?
      data[:value] = sap_value
    else
      data[:value] = 0.0
      flash[:warning] = l(:"currency.text_no_values_found_sap")
    end

  	if @range.update_attributes(data)
      flash[:notice] = l(:"currency.text_range_update_success")
    else
      flash[:error] = @range.get_error_message
    end

    redirect_to action: "show"
  end

  # Borrar intervalo
  def delete
    range = CurrencyRange.find_by_id(params[:id])

    if range.destroy
      flash[:notice] = l(:"currency.text_range_delete_success")
    else
      flash[:error] = cpm.get_error_message
    end

    redirect_to action:'show'
  end
end