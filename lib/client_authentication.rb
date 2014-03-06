class ClientAuthentication

  def initialize(key, params, path, method, time, signature=nil)
    @key          = key
    @params       = params
    @path         = path
    @method       = method
    @time         = time
    @signature    = signature
  end

  def authenticated?
    timeout && @signature == sign
  end

  def timeout
    Time.now.to_i - @time.to_i < 10
  end

end