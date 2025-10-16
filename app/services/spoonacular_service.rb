# app/services/spoonacular_service.rb
require "httparty"

class SpoonacularService
  include HTTParty

  base_uri "https://api.spoonacular.com"
  DEFAULT_TIMEOUT = 8 # seconds

  # Custom errors for better debugging
  class ApiError < StandardError; end
  class NotFoundError < ApiError; end
  class RateLimitError < ApiError; end
  class MissingApiKeyError < ApiError; end

  def initialize(api_key: nil, timeout: DEFAULT_TIMEOUT)
    @api_key =
      api_key ||
      ENV["SPOONACULAR_API_KEY"] ||
      Rails.application.credentials.dig(:spoonacular, :api_key)

    if @api_key.nil? || @api_key.empty?
      raise MissingApiKeyError, "SPOONACULAR_API_KEY not set in ENV or credentials"
    end

    @timeout = timeout
  end

  # 🔸 1. Search recipes by general query (name/keyword)
  # Example: search_recipes(query: "pasta", number: 10)
  def search_recipes(query:, number: 10, offset: 0, additional_params: {})
    params = {
      query: query,
      number: number,
      offset: offset,
      apiKey: @api_key
    }.merge(additional_params)

    resp = safe_get("/recipes/complexSearch", query: params)
    resp.parsed_response
  end

  # 🔸 2. Search recipes by ingredients
  # Example: search_recipes_by_ingredients("chicken,tomato")
  def search_recipes_by_ingredients(ingredients, number: 10)
    params = {
      ingredients: ingredients,
      number: number,
      apiKey: @api_key
    }

    resp = safe_get("/recipes/findByIngredients", query: params)
    resp.parsed_response
  end

  # 🔸 3. Get detailed info for one recipe by ID
  def get_recipe_details(spoonacular_id)
    resp = safe_get("/recipes/#{spoonacular_id}/information", query: { apiKey: @api_key })
    resp.parsed_response
  end

  # 🔸 4. Get bulk recipe details for multiple IDs
  def get_recipes_bulk(ids)
    ids_param = ids.is_a?(Array) ? ids.join(",") : ids.to_s
    resp = safe_get("/recipes/informationBulk", query: { ids: ids_param, apiKey: @api_key })
    resp.parsed_response
  end

  private

  # ✅ Centralized error handling
  def safe_get(path, query: {})
    begin
      resp = self.class.get(path, query: query, timeout: @timeout)

      case resp.code
      when 200
        resp
      when 404
        raise NotFoundError, "Resource not found: #{path}"
      when 401, 403
        raise ApiError, "Unauthorized: check your API key"
      when 402, 429
        raise RateLimitError, "Rate limit or billing issue (#{resp.code})"
      else
        raise ApiError, "Spoonacular API error: HTTP #{resp.code} - #{resp.body}"
      end

    rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, HTTParty::Error => e
      Rails.logger.error("[SpoonacularService] HTTP error: #{e.class} #{e.message}")
      raise ApiError, "Network error talking to Spoonacular: #{e.message}"
    end
  end
end
