 
require 'time'

module Literal
  Namespace.register :xsd, 'http://www.w3.org/2001/XMLSchema#'
  def xsd_type
    case self
      when String
      XSD::string
      when Integer
      XSD::integer
      when Float
      XSD::double
      when TrueClass, FalseClass
      XSD::boolean
      when DateTime, Date, Time
      XSD::date
    end
  end
  
  def self.typed(value, type)
    case type
      when XSD::string
      String.new(value)
      when XSD::date
      DateTime.parse(value)
      when XSD::dateTime, XSD::Time
      DateTime.parse(value)
      when XSD::boolean
      value == 'true' or value == 1
      when XSD::integer
      value.to_i
      when XSD::double
      value.to_f
    else
      String.new(value)
    end
  end
  def to_ntriple
     
    if $activerdf_without_xsdtype
      "\"#{to_s}\""     
    else      
      case xsd_type 
        when XSD::string
          "\"#{to_s}\""   
        when XSD::date
        DateTime.parse(to_s)
        when XSD::dateTime, XSD::Time
        DateTime.parse(to_s)
        when XSD::boolean
        to_s == 'true' or to_s == 1
        when XSD::integer
        to_s.to_i
        when XSD::double
        to_s.to_f
      else
     "\"#{to_s}\"^^#{xsd_type}"
      end 
    end
  end
end

class String; include Literal; end
class Integer; include Literal; end
class Float; include Literal; end
class DateTime; include Literal; end
class Date; include Literal; end
class Time; include Literal; end
class TrueClass; include Literal; end
class FalseClass; include Literal; end

class LocalizedString < String
  include Literal
  attr_reader :lang
  def initialize value, lang=nil
    super(value)
    if lang != nil
      @lang = lang
      @lang = lang[1..-1] if @lang[0..0] == '@'
    end
  end
  
  def to_ntriple
    if @lang
      "\"#{to_s}\"@#@lang"
    else
      super
    end
  end
end
