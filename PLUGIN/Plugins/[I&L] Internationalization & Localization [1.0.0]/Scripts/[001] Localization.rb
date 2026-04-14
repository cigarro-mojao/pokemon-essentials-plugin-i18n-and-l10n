#===============================================================================
#  Internationalization & Localization
#===============================================================================
module Localization
  module Settings
    #-----------------------------------------------------------------------------
    # List of available languages.
    #-----------------------------------------------------------------------------
    LANGUAGES = ::Settings::LANGUAGES
    #-----------------------------------------------------------------------------
    # Language used when no translation is needed or available.
    #-----------------------------------------------------------------------------
    DEFAULT_LANGUAGE = "english"
    #-----------------------------------------------------------------------------
    # Root folder for localized assets.
    #-----------------------------------------------------------------------------
    LOCALIZATION_DIRECTORY = "Localization/"
    #-----------------------------------------------------------------------------
    # List of directories that are localized in Localization/[language]/.
    # Only paths starting with these will be checked for translations.
    #-----------------------------------------------------------------------------
    LOCALIZED_DIRECTORIES = [
      "Graphics/Gameovers/",
      "Graphics/Icons/",
      "Graphics/Pictures/",
      "Graphics/Plugins/",
      "Graphics/Titles/",
      "Graphics/UI/",
    ]
  end
  #-----------------------------------------------------------------------------
  # Main entry point.
  # Returns the localized path if it exists, original otherwise.
  #-----------------------------------------------------------------------------
  def self.apply(file)
    # Skip if invalid file
    return file if file.nil? || file.empty?
    # Skip if we are in the default language
    return file if self.get_current_language == Settings::DEFAULT_LANGUAGE
    # Skip if the directory is not in our whitelist
    return file unless self.is_localized_directory?(file)

    localized_file = self.localize_file(file)
    
    return self.is_localized_file_valid?(localized_file) ? localized_file : file
  end
  #-----------------------------------------------------------------------------
  # Returns the name of the language folder based on $PokemonSystem.
  #-----------------------------------------------------------------------------
  def self.get_current_language
    return Localization::Settings::DEFAULT_LANGUAGE if Localization::Settings::DEFAULT_LANGUAGE.empty?
    return Localization::Settings::DEFAULT_LANGUAGE if !$PokemonSystem || !$PokemonSystem.language
    return Localization::Settings::LANGUAGES[$PokemonSystem.language][1]
  end
  #-----------------------------------------------------------------------------
  # Checks if the file path starts with any of the whitelisted folders.
  #-----------------------------------------------------------------------------
  def self.is_localized_directory?(file)
    return Localization::Settings::LOCALIZED_DIRECTORIES.any? { |f| file.start_with?(f) }
  end
  #-----------------------------------------------------------------------------
  # Constructs the full path for the localized asset.
  #-----------------------------------------------------------------------------
  def self.localize_file(file)
    return "#{Localization::Settings::LOCALIZATION_DIRECTORY}#{self.get_current_language}/#{file}"
  end
  #-----------------------------------------------------------------------------
  # Checks if the localized file exists and can be loaded.
  #-----------------------------------------------------------------------------
  def self.is_localized_file_valid?(file)
    return pbResolveBitmap(file) ? true : false
  end
end
