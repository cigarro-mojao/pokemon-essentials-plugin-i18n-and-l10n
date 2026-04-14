class AnimatedBitmap
  alias initialize_localized initialize
  
  def initialize(file, hue = 0)
    localized_file = Localization.apply(file)
    initialize_localized(localized_file, hue)
  end
end
