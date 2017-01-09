module Rambling
  module Trie
    module Configuration
      class ProviderCollection
        extend Rambling::Trie::Forwardable

        attr_reader :default, :name

        delegate [
          :[],
          :[]=,
          :keys,
          :values,
        ] => :providers

        def initialize name, providers = {}, default = nil
          @name = name
          @configured_providers = providers
          @configured_default = default || providers.values.first

          reset
        end

        def add extension, provider
          providers[extension] = provider
        end

        def default= item
          if providers.values.any? && !providers.values.include?(item)
            raise ArgumentError, "default #{name} should be part of configured #{name}s"
          end

          @default = item
        end

        def providers
          @providers ||= {}
        end

        def resolve filepath
          providers[format filepath] || default
        end

        def reset
          providers.clear
          configured_providers.each { |k, v| providers[k] = v }
          self.default = configured_default
        end

        private

        attr_reader :configured_providers, :configured_default

        def format filepath
          format = File.extname filepath
          format.slice! 0
          format.to_sym
        end
      end
    end
  end
end
