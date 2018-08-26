module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from Streem::Client::ElasticSearchError do
      render json: { error: I18n.t("errors.streem") }, status: 500
    end

    rescue_from Streem::Search::InvalidParamsError do
      render json: { error: I18n.t("errors.params") }, status: 400
    end
  end
end
