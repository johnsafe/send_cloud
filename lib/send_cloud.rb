require File.join(File.dirname(__FILE__), 'send_cloud','version.rb')

module SendCloud
  class EmailRecord
    attr_accessor :api_user,:api_key,:format
    require 'net/https'
    require 'uri'

    def initialize(args={})
      args[:format]||='xml'
      raise ArgumentError.new('user missing') if args[:api_user].nil?
      raise ArgumentError.new('key missing') if args[:api_key].nil?
      self.api_key=args[:api_key];self.api_user=args[:api_user];self.format=args[:format]
    end

    def method_missing(method,args)
      # 命名规则：以'_'分割成数组，最后一个元素为动作词，其余的重新以'_'组合成模块名称
      motion,model = separate_model_and_motion(method)
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      url = "https://sendcloud.sohu.com/webapi/#{model}.#{motion}.#{self.format}"
      post_api(url, args)
    end

    def separate_model_and_motion(method)
      method_array = method.to_s.split('_')
      raise ArgumentError.new('method format is wrong!') if method_array.size<2
      [method_array.pop,method_array.join('_')]
    end
    # 给列表发送
    def send_to_list(args)
      necessary_args = [:subject,:template_invoke_name,:from,:fromname,:use_maillist,:to]
      url = "https://sendcloud.sohu.com/webapi/mail.send_template.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      post_api(url, args)
    end
    # 给一个用户发送
    def send_to_user(args)
      necessary_args = [:subject,:template_invoke_name,:from,:fromname,:substitution_vars]
      url = "https://sendcloud.sohu.com/webapi/mail.send_template.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key})
      post_api(url, args)
    end
    # 普通发送（不使用邮件模板）
    def send_email(args)
      necessary_args = [:to,:subject,:html,:from]
      url = "https://sendcloud.sohu.com/webapi/mail.send.#{self.format}"
      necessary_args.to_a.each do |key|
        raise ArgumentError.new("#{key.to_s} is nil") if args[key].nil?
      end
      args.merge!({:api_user => self.api_user, :api_key => self.api_key,:use_maillist=>'false'})
      post_api(url, args)
    end
    private
    # post 方式
    def post_api(api, args)
      uri = URI.parse api
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(args)
      http.request(req).body
    end
    # get 方式
    def get_api(api, args)
      uri = URI.parse api
      uri.query = args.collect { |a| "#{a[0]}=#{URI::encode(a[1].to_s)}" }.join('&')
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Get.new(uri.request_uri)
      http.request(req).body
    end
  end
end