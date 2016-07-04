class TimeConverter
  def initialize timestamp
    integer_time = timestamp.to_i
    @timestamp   = Time.at(integer_time)
  end

  def get_slot_name
    '%02d' % @timestamp.hour
  end
end