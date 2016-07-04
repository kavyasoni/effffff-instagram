require 'open-uri'

class InstagramInterface
  def initialize user_id, tag
    user   = User.find(user_id)
    @token = user.ig_access_token
    @tag   = tag
  end

  # https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
  def hashtag_media letter=nil
    if Rails.env.test?
      return media_fixtures_for_test_environment letter=nil
    else
      return real_instagram_results_for_media
    end
  end

  # https://api.instagram.com/v1/tags/{tag-name}?access_token=ACCESS-TOKEN
  def single_tag_data tag
    if Rails.env.test?
      return fixture_for_test_environment tag
    else
      return real_instagram_result tag
    end
  end

  private

  def handle_instagram_api_error error
    response = error.io
    status   = response.status
    puts "ERROR status: #{status}"
    return :ig_status_429 if (status.include?(429) || status.include?('429'))
  end

  def real_instagram_result tag
    begin
      puts "\n\nSINGLE RESULT ATTEMPT for #{tag}\n\n"
      response = open("https://api.instagram.com/v1/tags/#{tag}?access_token=#{@token}").read
      response_object = JSON.parse(response)
      return response_object
    rescue OpenURI::HTTPError => error
      handle_instagram_api_error(error)
    end
  end

  def real_instagram_results_for_media
    results_list = []

    begin
      puts "\n\nMEDIA RESULT ATTEMPT for #{@tag}\n\n"
      response = open("https://api.instagram.com/v1/tags/#{@tag}/media/recent?access_token=#{@token}").read
      response_object = JSON.parse(response)

      response_object["data"].each do |image_object|
        single_image = {}
        single_image[:type]      = 'image'
        single_image[:likes]     = { count: image_object['likes']['count'] }
        single_image[:tags]      = image_object['tags']
        single_image[:id]        = image_object['id']
        single_image[:timestamp] = image_object['created_time']
        single_image[:url]       = image_object['images']['standard_resolution']['url']

        results_list.push single_image
      end

      return results_list
    rescue OpenURI::HTTPError => error
      handle_instagram_api_error(error)
    end
  end

  def fixture_for_test_environment tag
    return { "data": { media_count: 420, name: tag } }
  end

  def media_fixtures_for_test_environment letter=nil
    results_list  = []
    chosen_letter = letter || 'c'

    10.times do
      random_tags = []
      20.times do |index|
        random_tags.push ALL_WORDS.select { |x| x[0] == chosen_letter }[index]
      end

      random_tags = random_tags.uniq
      hash = { type: "image", tags: random_tags, likes: { count: rand(4000) },
               id: rand(10000000).to_s, created_at: Time.at(rand * Time.now.to_i).to_i }
      results_list.push hash
    end

    return results_list
  end
end