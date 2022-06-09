module Admin
  class BankloguploadsController < Admin::ApplicationController
    include AdminHelper
    def index
      @result_messages = []
    end

    def create
      upload = params[:banklogs]
      @result_messages = []
      i = 0
      upload.each_line do |line|
        i = i + 1
        @result_messages.push(process_banklog_upload(i, line.split('|')))
      end
      render 'index'
    end

  end
end