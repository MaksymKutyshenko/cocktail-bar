module ActiveRecordExtension

  extend ActiveSupport::Concern

  # add your instance methods here
  module ClassMethods
    PER_PAGE = 10

    def get_validated_page page
      page > 0 ? page - 1 : 0
    end

    def paginate args
      pagination_init args
      current_page = self.get_validated_page args[:page].to_i
      self.limit(@@per_page).offset(current_page * @@per_page)
    end

    def pagination_init args
      @@items_count = self.all.size
      @@per_page = (args[:per_page].blank? ? @@items_count : args[:per_page].to_i) || PER_PAGE
    end

    def per_page
      @@per_page
    end

    def items_count
      @@items_count
    end
  end
end

# include the extension
ActiveRecord::Base.send(:include, ActiveRecordExtension)