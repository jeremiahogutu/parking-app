class ParkingsController < ApplicationController
  before_action :set_parking, only: %i[show edit update destroy]

  # GET /parkings
  # GET /parkings.json
  def index
    @parkings = Parking.all
    number_of_spots = 7
    @current_parking_info = Parking.last
    @spots_available = number_of_spots - @parkings.count
    @time_difference = TimeDifference.between(Time.now, @current_parking_info.created_at).in_hours.floor
    @amount_due = final_payment(@time_difference)
  end

  def final_payment(time_difference)
    min_payment = 3
    if time_difference == 24
      hours = 1
      days =  1
      amount_due = calculate_payment(min_payment, hours) + (days * 10.25)
    elsif time_difference > 24
      hours = time_difference % 24
      days = time_difference / 24
      amount_due = calculate_payment(min_payment, hours) + (days * 10.25)
    else
      amount_due = calculate_payment(min_payment, time_difference)
    end
    amount_due
  end

  def calculate_payment(min_payment, time_difference)
    if time_difference <= 1
      min_payment
    elsif time_difference <= 3
      min_payment * 1.5
    elsif time_difference <= 6
      min_payment * 1.5 * 1.5
    else
      min_payment * 1.5 * 1.5 * 1.5
    end
  end

  # GET /parkings/1
  # GET /parkings/1.json
  def show
    # binding.pry
    @occupied_spots = Parking.all.count
    number_of_spots = 7
    @spots_available = number_of_spots - @occupied_spots
    @current_parking_info = Parking.find(params[:id])
    @time_difference = TimeDifference.between(Time.now, @current_parking_info.created_at).in_hours.floor
    @amount_due = if @current_parking_info.is_void
                    'Paid'
                  else
                    final_payment(@time_difference)
                  end
    respond_to do |format|
      format.js
    end
  end

  # GET /parkings/new
  def new
    @parking = Parking.new
  end

  # GET /parkings/1/edit
  def edit; end

  # POST /parkings
  # POST /parkings.json
  def create
    @parking = Parking.new(parking_params)
    respond_to do |format|
      if @parking.save
        @total_spots = Parking.all.count
        number_of_spots = 7
        @spots_available = number_of_spots - @total_spots
        @current_parking_info = Parking.last
        @time_difference = TimeDifference.between(Time.now, @current_parking_info.created_at).in_hours.floor
        @amount_due = final_payment(@time_difference)
        format.js
        format.html { redirect_to @parking, notice: 'Parking was successfully created.' }
        format.json { render :show, status: :created, location: @parking }
      else
        format.html { render :new }
        format.json { render json: @parking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parkings/1
  # PATCH/PUT /parkings/1.json
  def update
    respond_to do |format|
      if @parking.update(parking_params)
        format.html { redirect_to @parking, notice: 'Parking was successfully updated.' }
        format.json { render :show, status: :ok, location: @parking }
      else
        format.html { render :edit }
        format.json { render json: @parking.errors, status: :unprocessable_entity }
      end
    end
  end

  def pay_ticket
    # binding.pry
    @parkings = Parking.all
    @occupied_spots = Parking.all.count
    number_of_spots = 7
    @spots_available = number_of_spots - @occupied_spots
    @current_parking_info = Parking.find(params[:id])
    @current_parking_info.is_void = true
    @current_parking_info.save
    @amount_due = 'Paid'
    respond_to do |format|
      format.js
      format.html { redirect_to @parking, notice: 'Parking was successfully created.' }
      format.json { render :show, status: :created, location: @parking }
    end
  end

  # DELETE /parkings/1
  # DELETE /parkings/1.json
  def destroy
    @parking.destroy
    @total_cars = Parking.all.count
    number_of_spots = 7
    @spots_available = number_of_spots - @total_cars
    @current_parking_info = Parking.last
    @time_difference = TimeDifference.between(Time.now, @current_parking_info.created_at).in_hours.floor
    @amount_due = if @current_parking_info.is_void
                    'Paid'
                  else
                    final_payment(@time_difference)
                  end

    respond_to do |format|
      format.js
      format.html { redirect_to parkings_url, notice: 'Parking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parking
    @parking = Parking.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def parking_params
    params.require(:parking).permit(:license)
    # params.fetch(:parking, {})
  end
end
