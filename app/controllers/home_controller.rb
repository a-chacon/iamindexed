class HomeController < ApplicationController
  protect_from_forgery with: :null_session,
                       if: proc { |c| c.request.format =~ %r{application/json} }
  def search
    @url = params[:url]
  end

  def check
    @service = params[:service]
    @url = params[:url]

    result = SearchDomain.send(@service, SearchDomain.clean(@url))

    render json: {
      success: result.any?,
      data: result
    }, status: :ok
  end
end
