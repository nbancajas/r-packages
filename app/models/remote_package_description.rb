class RemotePackageDescription
  attr_reader :name, :version, :publication_date, :title, :description,
    :maintainer_field, :author_field

  def initialize(hash)
    @name             = hash["Package"]
    @version          = hash["Version"]
    @publication_date = hash["Date/Publication"]
    @title            = hash["Title"].force_encoding('utf-8')
    @description      = hash["Description"].force_encoding('utf-8')
    @author_field     = hash["Author"].force_encoding('utf-8')
    @maintainer_field = hash["Maintainer"].force_encoding('utf-8')
  end

  def maintainer
    @maintainer ||= OpenStruct.new(full_name: maintainer_full_name, email: maintainer_email)
  end

  def authors
    @authors ||= author_field
      .gsub(/\s\[[^\]]+\][^,]*/, '')
      .gsub(/[,\s]*and\s/, ',')
      .split(',')
      .map(&:strip)
  end

  private

  def maintainer_full_name
    @maintainer_full_name ||= parsed_maintainer.display_name
  end

  def maintainer_email
    @maintainer_email ||= parsed_maintainer.address
  end

  def parsed_maintainer
    @parsed_maintainer ||= Mail::Address.new(maintainer_field)
  end
end
