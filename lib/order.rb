class Order
  attr_reader :origin, :destination, :packages

  def initialize(params)
    @origin       = origin(params[:order][:origin])
    @destination  = destination(params[:order][:destination])
    @packages     = packages(params[:order][:packages])
  end

  def destination(destination_hash)
    Location.new(destination_hash)
  end

  def origin(origin_hash)
    Location.new(origin_hash)
  end

  def packages(packages)
    packages.map do |package|
      pkg_weight = package[:weight].to_i
      pkg_dimensions = package[:dimensions].split(',').map { |dimension| dimension.to_i }
      Package.new(pkg_weight, pkg_dimensions, units: package[:units])
    end
  end
end
