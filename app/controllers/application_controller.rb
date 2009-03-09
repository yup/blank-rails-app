class ApplicationController < ActionController::Base
  include Authentication
  helper :all
  protect_from_forgery
  filter_parameter_logging :password
  
  
  rescue_from ActiveRecord::RecordInvalid, :with => :handle_invalid_record
  
  private
  
  # Call .create! and .update_attributes!, which will raise an exception and
  # render either new or edit, depending on the state of the record, if the
  # validation failed.
  def handle_invalid_record(exception)
    render :action => (exception.record.new_record? ? "new" : "edit" )
  end
end
