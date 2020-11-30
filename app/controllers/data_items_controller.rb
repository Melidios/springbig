class DataItemsController < ApplicationController
  expose :data_item
  expose :processed_data_items do
    DataItem.where(file_name: session[:file_name])
  end

  def input
  end

  def create
    session[:file_name] = data_item_params[:file_name]
    return unless session[:file_name].present?

    flash[:var] = ProcessCsvJob.call(data_item_params[:file], session[:file_name])
    redirect_to data_items_output_path
  end

  def output
    @result = flash[:var] || []
  end

  private

  def data_item_params
    params.require(:data_item).permit(:file_name, :file)
  end
end
