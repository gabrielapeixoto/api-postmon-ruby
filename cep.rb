require 'json'
require 'open-uri'
require 'nokogiri'


module Postmon
  # endereço base da api
  BASE_URI = "https://api.postmon.com.br/v1"

  # classe da api
  class API
    attr_accessor :entity

    # obtém e retorna os dados do cep
    def by_cep(value)
      begin
        open(uri_to("/cep/#{value}")) do |res|
          entity = Postmon::API::Entity.new;
          entity.parse(res.readlines.join)
        end
      rescue Exception => e
        puts "Erro ao retornar os dados do CEP! (#{e.message})"
        exit
      end
    end

    private
    # constroi a url
    def uri_to(uri)
      URI(URI::encode("#{BASE_URI}/#{uri}")) 
    end
  end

  # classe da entidade (retorno da API)
  class API::Entity
    attr_reader :bairro, :cidade, :cep, :logradouro, :estado, :estado_info, :cidade_info

    # parseia as informações
    def parse(json)
      o = JSON::parse(json)
      @cep         = o["cep"]
      @bairro      = o["bairro"]
      @cidade      = o["cidade"]
      @estado      = o["estado"]
      @logradouro  = o["logradouro"]
      @estado_info = o["estado_info"]
      @cidade_info = o["cidade_info"]

      self
    end
  end
end



# objeto do nosso client da API
postmon = Postmon::API.new

# obtendo os dados do cep
location = postmon.by_cep("28035582")

# imprimindo as informações do cep
puts "INFORMAÇÕES PARA O CEP #{location.cep}"
puts "=" * 60

puts "Rua   : #{location.logradouro}" if location.logradouro
puts "Bairro: #{location.bairro}" if location.bairro
puts "Cidade: #{location.cidade}"
puts "Estado: #{location.estado}"
