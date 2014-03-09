class ClientAuthentication
  def initialize(key, params, path, method, time, signature)
    @key          = key
    @params       = params
    @path         = path
    @method       = method
    @time         = time
    @signature    = signature
  end

  def sign
    Base64.encode64(OpenSSL::HMAC.digest(digest, @key, data)).chomp
  end

  def authenticated?
    timeout && @signature == sign
  end

  def data
    @params[:path] = @path
    @params[:method] = @method
    @params[:time] = @time
    JSON.dump(@params)
  end

  def digest
    OpenSSL::Digest::Digest.new('sha1')
  end

  def timeout
    Time.now.to_i - @time.to_i < 10
  end
end
