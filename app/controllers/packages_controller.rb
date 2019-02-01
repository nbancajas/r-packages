class PackagesController < ApplicationController
  def index
    @packages = Package.includes(:latest_version).page(params[:page])
  end

  def show
    @package = Package.includes(:versions, :latest_version).find(params[:id])
  end
end
