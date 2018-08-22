class Parking < ApplicationRecord
  def self.get_amount(parking_id)
    @current_parking_info = Parking.find(parking_id)
    @time_difference = TimeDifference.between(Time.now, @current_parking_info.created_at).in_hours.floor
    @amount_due = final_payment(@time_difference)
    @amount_due
  end

  def self.final_payment(time_difference)
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

  def self.calculate_payment(min_payment, time_difference)
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
end
