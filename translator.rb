require 'httparty'
require 'iso-639'
require 'rexml/document'

class RandomTranslator
  LANGUAGES = %w(ar bg ca zh-CHS zh-CHT cs da nl en et fi fr de el ht he hi mww hu id it ja tlh tlh-Qaak ko lv lt ms mt no fa pl pt ro ru sk sl es sv th tr uk ur vi cy)
  ENDPOINT_URL = 'https://api.datamarket.azure.com/Bing/MicrosoftTranslator/v1/Translate'
  NAMESPACES = {
    'd' => 'http://schemas.microsoft.com/ado/2007/08/dataservices',
    'm' => 'http://schemas.microsoft.com/ado/2007/08/dataservices/metadata'
  }

  def initialize(app_key)
    @app_key = app_key
  end

  def translate(text, from)
    to = random_language
    query = { Text: quote(text), From: quote(from), To: quote(to) }
    response = HTTParty.get(ENDPOINT_URL, { query: query, basic_auth: auth })

    translated = extract_result(response.body)
    to_name = language_name(to)

    "#{translated} in #{to_name}"
  end

  private

  def extract_result(xml)
    doc = REXML::Document.new(xml)
    REXML::XPath.first(doc, '//d:Text[@m:type="Edm.String"]', NAMESPACES).text
  end

  def random_language
    LANGUAGES[rand(LANGUAGES.size)]
  end

  def quote(text)
    "'#{text}'"
  end

  def auth
    { username: @app_key, password: @app_key }
  end

  def language_name(code)
    ISO_639.find(code.split('-')[0]).english_name
  end
end
