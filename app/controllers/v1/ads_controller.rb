class V1::AdsController < ApplicationController
  def search
    params_for_flipkart = {:query => params["query"], :resultCount => 10}
    method = "get"
    request_url = "https://affiliate-api.flipkart.net/affiliate/search/json"
    res = RestClient.get(request_url, {"params" => params_for_flipkart, "Fk-Affiliate-Id" => "anirudhkk", "Fk-Affiliate-Token" => "8ccde2806ae14015a1a31112b18e117e"})
    response = JSON.parse(res.body)
    @productInfoList = []
    response["productInfoList"].each do |x|
      data = OpenStruct.new
      data.title = x["productBaseInfo"]["productAttributes"]["title"]
      data.image = x["productBaseInfo"]["productAttributes"]["imageUrls"]["200x200"]
      data.url = x["productBaseInfo"]["productAttributes"]["productUrl"]
      data.price = x["productBaseInfo"]["productAttributes"]["sellingPrice"]["currency"] + " " + x["productBaseInfo"]["productAttributes"]["sellingPrice"]["amount"].to_s
      @productInfoList.push(data)

    end
    render "v1/ads/search"
  end

  def amenities
    @client = GooglePlaces::Client.new(Rails.application.config.google_api_key)
    params_for_lat_lng = {
        :address => "Koramangala%2C%20Sarjapur%20Main%20Rd%2C%20Koramangala%202B%20Block%2C%20Bengaluru%2C%20Karnataka%20560034%2C%20India",
        :key => Rails.application.config.google_api_key
    }

    res = RestClient.get("https://maps.googleapis.com/maps/api/geocode/json", {"params" => params_for_lat_lng})
    @amenities = @client.spots(JSON.parse(res)["results"][0]["geometry"]["location"]["lat"], JSON.parse(res)["results"][0]["geometry"]["location"]["lng"], :radius => Rails.application.config.default_radius, :types => ["#{params[:query].downcase}"])
    render "v1/ads/amenities"
  end

  def get_estimates
    params = {
        :origins => "41.43206,-81.38992",
        :destinations => "Darling+Harbour+NSW+Australia",
        :key => "AIzaSyCG0jxq63mFlEwrGekNbfzELNBmlb8DGg8"
    }
    res = RestClient.get("https://maps.googleapis.com/maps/api/distancematrix/json", {:params => params})
    response = JSON.parse(res.body)
  end

  def add_to_cart
    title = params[:title]
    image = params[:image]
    url = params[:url]
    price = params[:price]
    unless title.present? && image.present? && url.present? && price.present?
      error(401, "Parameters missing", "Title,image, Url and price are required") and return
    end
    order = Order.new({
                       :title => title,
                       :image => image,
                       :url => url,
                       :price => price
                   })
    order.save!
    render "shared/success"
  end

  def init
    Order.delete_all
    render "shared/success"
  end

  def view_cart
    @orders = Order.all.each
    render "v1/ads/order"
  end

  def book_cab
    client = Uber::Client.new do |config|
      config.server_token  = "JGNrvgMaTzVgxZAptfrlQOc2cTJiS1boHG9e0wOf"
      config.client_id     = "GkxvSfRWLMJreTaCe0mKji53SSYGss0E"
      config.client_secret = "JGNrvgMaTzVgxZAptfrlQOc2cTJiS1boHG9e0wOf"
      config.bearer_token  = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzY29wZXMiOlsicHJvZmlsZSIsInJlcXVlc3QiLCJoaXN0b3J5X2xpdGUiLCJkZWxpdmVyeSIsInJlcXVlc3RfcmVjZWlwdCIsImRlbGl2ZXJ5X3NhbmRib3giLCJoaXN0b3J5Il0sInN1YiI6IjQxZjY2ZjFhLTI0NGYtNDVlZi04MzgyLTY3MzNmZWZlNmQ0NiIsImlzcyI6InViZXItdXMxIiwianRpIjoiODJhZDY1ZDktYmNjZS00MGRjLTk5ZTQtYmJlMDFlYTgxYTFkIiwiZXhwIjoxNDQ4OTE0Mzg5LCJpYXQiOjE0NDYzMjIzODksInVhY3QiOiI2Y2hsQ2Vxd2pwczZUVGt0b2pSaWtWM0V5OFBtZmUiLCJuYmYiOjE0NDYzMjIyOTksImF1ZCI6IkdreHZTZlJXTE1KcmVUYUNlMG1Lamk1M1NTWUdzczBFIn0.l6FWvd1T4koSfOnwmcrFJDj7gZLeJT16VLUan5c7rilammEXMdRVGnS41Qat7eUS490wdQUP2lyq53OXdUsSTgfSEyBoy2sYDtIrBWkfvorLlSafDwldfyjF45XzM7i5fRwmTgbypLTBrtumoA8Qtv628K4wD0kh5Nin6qqgviOzf0yAFYQYTMS_IUxNJJusmySxWk1ybVxBi5b2qQI7ozi9lIYZti0hBoN8jqya_eBZRO-301Ep22WpqVghqZNSGNTLYi0zjYtZuadIJnHW1OpT6RbgopJ0ZidZErcBkpFtCYovYGAl2NmvY-mZSgK3U4sUMCo-kpXUazuMJq7V0g"
    end
    request = Uber::Request.new do

    end
    render "shared/success"
  end

end
