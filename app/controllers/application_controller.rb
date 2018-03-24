class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with name: Rails.application.secrets.fetch(:name),
                               password: Rails.application.secrets.fetch(:password)
end
