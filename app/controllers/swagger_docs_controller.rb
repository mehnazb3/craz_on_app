class SwaggerDocsController < ApplicationController
  skip_before_action :authenticate_user_token!

  def index
  end
end
