class UberService

  def initialize(user, parameters = {})
    # Attention au token il faut le rafraichir !!
    @bearer_token = user.uber_token

    # On se limite à commander des uberX pour l instant
    @product_id = "5b451799-a7c3-480e-8720-891f2b51abb4"

    # Coordonnées pour la commande
    @start_latitude = parameters[:start_latitude]
    @start_longitude = parameters[:start_longitude]
    @end_latitude = parameters[:end_latitude]
    @end_longitude = parameters[:end_longitude]

    # Token d'environnemnt de l'app sur uber, pas propre au user
    # EST-CE NECESSAIRE ?? car deja dans uber.rb
    @client_secret = ENV['UBER_CLIENT_SECRET']
    @client_id = ENV['UBER_CLIENT_ID']
    @server_token = ENV['UBER_SERVER_TOKEN']

    # Instancie un client avec tous ses tokens et codes d'accès, et les notres
    @client = Uber::Client.new(sandbox: (Rails.env == "development"), server_token: @server_token, client_secret: @client_secret, client_id: @client_id, bearer_token: @bearer_token)
  end

  def price_estimates
    @client.price_estimations(start_latitude: @start_latitude, start_longitude: @start_longitude,
                             end_latitude: @end_latitude, end_longitude: @end_longitude)
  end

  def update_params
    # TODO: possibilité de changer les params de départ et arrivée en cas d'erreur
  end

  def account_details
    @client.me
  end

  def ride_request
    @client.trip_request(product_id: @product_id, start_latitude: @start_latitude, start_longitude: @start_longitude, end_latitude: @end_latitude, end_longitude: @end_longitude)
  end

  def ride_details(request_id)
    @client.trip_details request_id
  end

  def ride_status_update(request_id, status)
    @client.trip_update(request_id, status)
  end

  def cancel_request(request_id)
    @client.trip_cancel request_id
  end
end


# api_object = UberService.new(moi, params)


# exemple de parameters pour une course du Wagon à chez Emeric
#  parameters = {
    #   :start_latitude => 48.864667,
    #   :start_longitude => 2.378838,
    #   :end_latitude => 48.852115,
    #   :end_longitude => 2.268011
    # }
    #

#
# curl -X "PUT" "https://sandbox-api.uber.com/v1/sandbox/requests/426893b5-fffd-4720-9378-8b2d3f170406" \
#   -H "Authorization: Bearer OyrSkv9U7083snAS0sYKhukL5BtlTn" \
#   -H "Content-Type: application/json" \
#   -d "{\"status\":\"accepted\"}"
