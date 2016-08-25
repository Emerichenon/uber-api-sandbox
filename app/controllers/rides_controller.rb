class RidesController < ApplicationController

  def new
    @ride = Ride.new
  end

  def create
    @ride = Ride.new(ride_params)
    @ride.user = current_user
    @ride.save

    redirect_to ride_path(@ride)
  end

  def show
    @ride = Ride.find(params[:id])
  end

  def price_estimate

    @ride = Ride.find(params[:ride_id])
    uber_api_object = UberService.new(@ride.user, { start_latitude: @ride.start_latitude, start_longitude: @ride.start_longitude, end_latitude: @ride.end_latitude, end_longitude: @ride.end_longitude })
    @response = uber_api_object.price_estimates

    # On indique qu'on attend du js, qui va se lier au remote: true de la vue
    respond_to do |format|
      format.js
    end
  end

  def ride_request

    # appel de la gem uber-ruby pour passer la request
    @ride = Ride.find(params[:ride_id])

    uber_api_object = UberService.new(@ride.user, { start_latitude: @ride.start_latitude, start_longitude: @ride.start_longitude, end_latitude: @ride.end_latitude, end_longitude: @ride.end_longitude })
    @response = uber_api_object.ride_request

    # Stocke l'id de la request dans le ride
    @ride.update(request_id: @response.request_id)

    # response traitée en ajax dans la show
    respond_to do |format|
      format.js
    end
  end

  def edit_status
    @ride = Ride.find(params[:ride_id])
    uber_api_object = UberService.new(@ride.user, { start_latitude: @ride.start_latitude, start_longitude: @ride.start_longitude, end_latitude: @ride.end_latitude, end_longitude: @ride.end_longitude })
    # j'édite le statut
    edit_response = uber_api_object.ride_status_update(@ride.request_id, params[:status])

    # je stocke les nouveaux détails du ride
    @response = uber_api_object.ride_details(@ride.request_id)

    # response traitée en ajax dans la show, qui édite les infos dynamiquement
    respond_to do |format|
      format.js
    end
  end

  def cancel_request
    @ride = Ride.find(params[:ride_id])
    uber_api_object = UberService.new(@ride.user, { start_latitude: @ride.start_latitude, start_longitude: @ride.start_longitude, end_latitude: @ride.end_latitude, end_longitude: @ride.end_longitude })

    # j'édite le statut à cancel
    edit_response = uber_api_object.cancel_request(@ride.request_id)

    # Je stocke les nouveaux détails de ride
    @response = uber_api_object.ride_details(@ride.request_id)

    respond_to do |format|
      format.js
    end
  end

  private

  def ride_params
    params.require(:ride).permit(:start_latitude, :start_longitude, :end_longitude, :end_latitude, :user, :request_id)
  end
end
