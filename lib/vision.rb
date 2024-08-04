require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
      # 画像をbase64にエンコードするのを定義してしまう。
    def get_base64_image(image_file)
      Base64.encode64(image_file.tempfile.read)
    end

    # タグを取得する機能用
    def get_image_data(base64_image)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      # こちらからAPIリクエストを送るためのJSON化。google_cloud_vision公式通り。
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: 'LABEL_DETECTION'
            }
          ]
        }]
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)
      # APIレスポンス出力
      if (error = response_body['responses'][0]['error']).present?
        raise error['message']
      else
        response_body['responses'][0]['labelAnnotations'].pluck('description').take(3)
      end
    end
    
    # ドミナントカラー解析用
    def analyze_image(base64_image)
      # APIキーを環境変数として渡す。（同じ）
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"
      
      # 画像データと解析したい内容（今回は色情報が欲しいのでイメージプロパティを選択）を指定
      params = {
       requests: [{
         image: {
           content: base64_image
         },
         features: [{
           type: "IMAGE_PROPERTIES",
           maxResults: 3
         }]
       }]
      }.to_json
      
      # HTTPオブジェクトを使ってHTTPリクエストを作成。
      # POSTメソッド+ヘッダーに'Content-Type' => 'application/json'を指定。
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' => 'application/json'})
      response = https.request(request, params)
      response_body = JSON.parse(response.body)
      
      # レスポンスのHTTPステータスコードが200（成功）の場合、レスポンスボディから色情報を抽出。
      if response.code == '200'
        color_full_data = JSON.parse(response.body)['responses'][0]['imagePropertiesAnnotation']['dominantColors']['colors']
        color_full_data.map do |color|
          {
            red: color["color"]["red"],
            green: color["color"]["green"],
            blue: color["color"]["blue"],
            score: color["score"],
            pixel_fraction: color["pixelFraction"]
          }
        end
      end
    end
  end
end