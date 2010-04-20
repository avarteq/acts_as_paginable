module Avarteq
  module Paginator

    def self.included(base)      
      base.extend(ClassMethods)
    end

    module ClassMethods

      # +options[:scopes]+:: List with paginable scopes
      def acts_as_paginable(options = {})

        # Accessors for class (static) variables
        cattr_accessor :paginable_scopes, :paginable_scope_prefix, :paginable_params_suffix

        self.paginable_scopes         = options[:scopes] || []
        self.paginable_scope_prefix   = options[:scope_prefix] || "scoped_by_"
        self.paginable_params_suffix  = options[:params_suffix] || ""
      end

      def atq_paginate(params, per_page)
        result = self
        self.paginable_scopes.each do |scope_name|
          param_name = scope_name.to_s + self.paginable_params_suffix.to_s          
          if params[param_name] && !params[param_name].empty? then
            args    = params[param_name]
            scope   = (self.paginable_scope_prefix + scope_name.to_s ).to_sym
            result  = result.send(scope, args)
          end
        end
        result.paginate(:page => params[:page], :per_page => per_page)
      end
    end
  end
end

ActiveRecord::Base.send :include, Avarteq::Paginator