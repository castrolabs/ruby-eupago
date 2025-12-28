module EuPago
  module Api
    module V1
      class References
        # Fetches references with optional parameters.
        #
        # @param params [Hash] Optional parameters for the request.
        # @option params [String] :identifier Insert the identifier that you want to find on your search.
        # @option params [String] :reference Insert the reference you want to find in your search.
        # @option params [String] :start_date Specify the first date you want to search (YYYY-MM-DD). We will provide all references since that date.
        #
        # @docs https://eupago.readme.io/reference/advanced-search
        def self.list(params = {})
          V1.oauth_client.get("/management/v1.02/references/info", query: params)
        end

        # Fetches references by status with optional parameters.
        #
        # @param params [Hash] Optional parameters for the request.
        # @option params [String] :status Choose the status to search (EuPago::Constants::REFERENCE_STATUS)
        # @docs https://eupago.readme.io/reference/references-by-status
        #
        def self.list_by_status(params = {})
          V1.oauth_client.get("/management/v1.02/references", query: params)
        end


        # Fetches reference information by reference and entity.
        #
        # @param body [Hash] Required parameters for the request.
        # @option body [String] :referencia Reference identifier to search for.
        # @option body [String] :entidade Entity associated with the reference (Not all services have an entity).
        #
        # @return [Hash] Reference information response from the API.
        #
        # @docs https://eupago.readme.io/reference/reference-information
        def self.find(body)
          V1.body_client.post("/clientes/rest_api/multibanco/info", body: body)
        end

        # =========
        # Alias Methods
        # =========

        # Fetches reference information by reference.
        # @alias find_by_reference for find method with reference parameter.
        #
        def self.find_by_reference(reference, body = {})
          self.find(body.merge({ referencia: reference }))
        end
      end
    end
  end
end
