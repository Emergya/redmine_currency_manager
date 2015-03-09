class CurrencyRangesController < ApplicationController
  unloadable

  before_filter :authorize_global, :only => [:show]
  
  def show
  	@ranges = CurrencyRange.get_ranges #find(:all, :conditions => ["start_date IS NOT NULL AND due_date IS NOT NULL"])
  end

  def add
  	data = params[:currency_range]

  	@range = CurrencyRange.new(data)

    sap_value = SapConnection.get_value(@range[:currency], data[:due_date])

    if sap_value.present?
      @range[:value] = sap_value
    else
      @range[:value] = 0.0
      flash[:warning] = "No values found in SAP"
    end

  	if @range.save
  		flash[:notice] = "The range has been created successfully" 
    else
  		flash[:error] = @range.get_error_message
    end

    redirect_to action: "show"
  end

=begin
  def edit
    data = params[:currency_ranges]

  	@range = CurrencyRanges.find_by_id(data[:id])

  	if @range.update_attributes(data)
      flash[:notice] = "The range has been edit successfully"
    else
      flash[:error] = @range.get_error_message
    end

    redirect_to action: "show"
  end
=end

  def update
  	data = params[:currency_range]

  	@range = CurrencyRange.find_by_id(data[:id])

  	sap_value = SapConnection.get_value(@range[:currency], data[:due_date])

    if sap_value.present?
      data[:value] = sap_value
    else
      data[:value] = 0.0
      flash[:warning] = "No values found in SAP"
    end

  	if @range.update_attributes(data)
      flash[:notice] = "The range has been updated successfully"
    else
      flash[:error] = @range.get_error_message
    end

    redirect_to action: "show"
  end

  def delete
    range = CurrencyRange.find_by_id(params[:id])

    if range.destroy
      flash[:notice] = "The range has been deleted successfully"
    else
      flash[:error] = cpm.get_error_message
    end

    redirect_to action:'show'
  end
end