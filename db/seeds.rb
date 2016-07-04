# create a bunch of random hashtags

creatable_hashtags = []
creatable_timeslots = []

puts "generating hashtags"

TIMESLOT_LABELS.each_with_index do |slot, slot_index|
  rand_times = rand(50)

  rand_times.times do |i|
    puts "#{slot_index + 1} of #{TIMESLOT_LABELS.size} | #{i + 1} of #{rand_times}"
    random_number = rand(10000)
    random_label  = (0...5).map { ('a'..'z').to_a[rand(26)] }.join
    creatable_hashtags.push Hashtag.new(label: random_label, total_count_on_ig: random_number)
  end
end

# import the hashtags into the DB

Hashtag.ar_import creatable_hashtags

# create a timeslot for each hashtag

all_hashtags = Hashtag.all
all_tags = Hashtag.pluck(:label)
hashtag_count = Hashtag.count

Hashtag.all.each_with_index do |x, index|
  TIMESLOT_LABELS.each do |slot|
    creatable_timeslots.push Timeslot.new(slot_name: slot, hashtag_id: x.id)
  end

  if creatable_timeslots.size > 10000
    puts "importing timeslot batch #{index + 1} of #{hashtag_count}"
    Timeslot.ar_import creatable_timeslots
    creatable_timeslots = []
  end
end

Hashtag.all.each_with_index do |tag, index|
  random_list = []

  puts "updating hashtag #{index + 1} of #{hashtag_count}"

  while random_list.size < 50
    random_list.push all_tags[rand(all_tags.length), rand(all_tags.length - 1) + 1]
  end

  sorted_list = random_list.flatten[0..50]
  list_of_ids = all_hashtags.select { |x| x.label == sorted_list }.map(&:id)
  tag.update(related_hashtags: sorted_list, raw_related_hashtags: sorted_list, related_hashtag_ids: list_of_ids)
end