module Admin
  class ExploguploadsController < Admin::ApplicationController
    include AdminHelper
    def index
      @result_messages = []
    end

    def create
      upload = params[:explogs]
      @result_messages = []
      i = 0
      upload.each_line do |line|
        i = i + 1
        @result_messages.push(process_upload_exp(i, line.split('|')))
      end
      render 'index'
    end

  end
end