# Error module to Handle errors globally
# include Error::ErrorHandler in application_controller.rb

# Refactored ErrorHandler to handle multiple errors
# Rescue StandardError acts as a Fallback mechanism to handle any exception

# standard error includes 
  # ArgumentError
  # IOError
  #   EOFError
  # IndexError
  # LocalJumpError
  # NameError
  #   NoMethodError
  # RangeError
  #   FloatDomainError
  # RegexpError
  # RuntimeError
  # SecurityError
  # SystemCallError
  # SystemStackError
  # ThreadError
  # TypeError
  # ZeroDivisionError

  module Errors
    module ErrorHandler
      class AuthorizationError < StandardError; end
  
      def self.included(clazz)
        clazz.class_eval do
  
          # rescue from all type of Standard Errors
          rescue_from StandardError do |e|
            exception_logger(:standard_error, 500, e.to_s)
            json = respond(:standard_error, 500, e.to_s)
            render json: json, status: :not_found
          end
  
          # rescue from Record Not Found Error
          rescue_from ActiveRecord::RecordNotFound do |e|
            exception_logger(:record_not_found, 404, e.to_s)
            json = respond(:record_not_found, 404, e.to_s)
            render json: json, status: :not_found
          end
        end
      end
  
      private

      def respond(_error, _status, _message)
        json = {
                error: _error,
                status: _status,
                message: _message
              }.to_json
        return json
      end
  
      def exception_logger(_error, _status, _message)
        new_logger = Logger.new('log/exceptions.log')
        new_logger.error("#{_error}, #{_status}, #{_message}")
      end
    end
  end
