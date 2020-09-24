class CustomError
    def initialize(message=nil)
        @errors = []
        @errors << message unless message.blank?
    end

    def add(message)
        raise_if_no_message_provided(message)
        @errors.append(message)
        self
    end
    
    def size
        @errors.size
    end

    def none?
        size.zero?
    end

    def all
        @errors
    end

    def to_sentence
        @errors.to_sentence.capitalize
    end

    def convert(errors)
        class_type = errors.class.to_s
        messages = []
        messages = errors.full_messages if class_type == 'ActiveModel:Errors'
        messages = errors if class_type == 'Array'
        messages = errors&.errors&.full_messages || [] unless class_type.in?(%w[Array ActiveModel::Errors])
        messages.each { |error| @errors << error }
        self
    end
    
    private

    def raise_if_no_message_provided(message)
        raise "Must provide usable error message!" if message.blank?
    end
end
