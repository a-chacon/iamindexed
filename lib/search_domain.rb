require "nokogiri"
require "http"
require "uri"
require "cgi"

module SearchDomain
  ##
  # Remove protocol and extra data to url
  #
  def self.clean(url)
    URI.parse(url).host
  end

  ##
  # Search a domain in Google engine.
  #
  def self.google(domain, http_service: HTTP, parser_service: Nokogiri)
    url = "https://www.google.com/search?q=site%3A#{domain}&gl=us"
    headers = {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
    }
    unparsed_page = http_service.headers(headers).get(url)
    parsed_page = parser_service::HTML(unparsed_page.to_s)

    results = []
    parsed_page.css("div.g").each do |result|
      link = result.css(".yuRUbf > a").first
      link_href = link.nil? ? "" : link["href"]
      result_hash = {
        title: result.css("h3").text,
        link: link_href,
        snippet: result.css(".VwiC3b").text,
      }
      results << result_hash
    end
    results
  end

  ##
  # Search a domain in DuckDuckGo Engine.
  # TODO: complete this too
  def self.duckduckgo(domain, http_service: HTTP, parser_service: Nokogiri)
    url = "https://html.duckduckgo.com/html/?q=site%3Aa-chacon.com&hps=1&atb=v302-1&ia=web"
    headers = {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
      "Host": "duckduckgo.com",
      "accept": "*/*",
    }

    unparsed_page = http_service.headers(headers).get(url)
    print(unparsed_page.code)
    parsed_page = parser_service::HTML(unparsed_page.to_s)
    print(parsed_page)
    results = []
    parsed_page.css("div.result").each do |result|
      puts("------------------------------------------------------------------------")
      puts(result)
      result_hash = {
        title: result.css("h2.result__title").text,
      }
      results << result_hash
    end

    results
  end

  ##
  # Search a domain in Bing Engine.
  #
  def self.bing(domain, http_service: HTTP, parser_service: Nokogiri)
    url = "https://www.bing.com/search?q=site%3A#{domain}"
    headers = {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
    }
    unparsed_page = http_service.headers(headers).get(url)
    parsed_page = parser_service::HTML(unparsed_page.to_s)
    results = []
    parsed_page.css("li.b_algo").each do |result|
      result_hash = {
        title: result.css("h2 a").text,
        link: result.css("cite").text,
        snippet: result.css("div p").text,
      }
      results << result_hash
    end

    results.select { |r| r[:link].include? domain }
  end

  ##
  # Search a domain in Yahoo Engine.
  #
  def self.yahoo(domain, http_service: HTTP, parser_service: Nokogiri)
    url = "https://search.yahoo.com/search?p=site%3A#{domain}"
    headers = {
      "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36",
    }
    unparsed_page = http_service.headers(headers).get(url)
    parsed_page = parser_service::HTML(unparsed_page.to_s)
    # return parsed_page
    results = []
    parsed_page.css("div.algo").each do |result|
      url_encoded = result.css("a.va-bot").first["href"].split("/").find { |y| y.start_with? "RU=" }.gsub("RU=", "")
      link = CGI.unescape(url_encoded)
      result_hash = {
        title: result.css("a.va-bot").text,
        link:,
        snippet: result.css("div p").text,
      }
      results << result_hash
    end

    results
  end

  ##
  # Search a domain in Baidu Engine.
  # TODO: not working too
  def self.baidu(domain, http_service: HTTP, parser_service: Nokogiri)
    url = "https://image.baidu.com/search/index?tn=baiduimage&word=#{domain}"
    headers = {
      "Host": "www.baidu.com",
      "User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0",
      "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
      "Accept-Language": "es-CL,en;q=0.5",
      "Accept-Encoding": "gzip, deflate, br",
      "DNT": "1",
      "Connection": "keep-alive",
      "Upgrade-Insecure-Requests": "1",
      "Sec-Fetch-Dest": "document",
      "Sec-Fetch-Mode": "navigate",
      "Sec-Fetch-Site": "none",
      "Sec-Fetch-User": "?1",
      "Sec-GPC": "1",
    }
    # headers = {
    # "User-Agent": 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.54 Safari/537.36'
    # }
    unparsed_page = http_service.headers(headers).get(url)
    parsed_page = parser_service::HTML(unparsed_page.to_s)
    p parsed_page.to_s
    results = []
    parsed_page.css("div.c-container").each do |result|
      p result["mu"]
      # result_hash = {
      # title: result.css('a.va-bot').text,
      # link: '',
      # snippet: result.css('div p').text
      # }
      # results << result_hash
    end

    results
  end
end
